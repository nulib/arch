# frozen_string_literal: true

# Tracks zipped work files that are created on demand, and then cached in a store.
# The store is expected to be purged periodically, which the db is not told about,
# so the actual file may not exist.
#
# This model is responsible for determining the file name, created from work id
# and checksum, so if the checksum changes, we'll look for a new file and not
# use the old one (which will then be eventually purged by the store)
class CloudStorageArchive < ApplicationRecord
  STALE_IN_PROGRESS_SECONDS = 20.minutes
  ERROR_RETRY_SECONDS = 10.minutes

  enum status: %w[in_progress success error].map { |v| [v, v] }.to_h.freeze

  delegate :file_exists?, :url, :write_from_path, to: :resource_locator

  def file_name
    "#{work_id}_#{checksum}.zip"
  end

  def work_presenter
    @work_presenter ||= Hyrax::GenericWorkPresenter.new(
      SolrDocument.find(work_id),
      Ability.new(nil)
    )
  end

  def self.find_or_create_record(id, work_presenter: nil)
    FindOrCreator.new(id, work_presenter: work_presenter).find_or_create_record
  end

  protected

    def resource_locator
      @resource_locator ||= S3File.new(self, Settings.aws.buckets.archives, download_name)
    end

    def download_name
      "#{first_three_words(work_presenter.title)}_#{work_presenter.id}.zip"
    end

    def first_three_words(title)
      title.first.gsub(/[']/, '').gsub(/([[:space:]]|[[:punct:]])+/, ' ').split.slice(0..2).join('_').downcase[0..25]
    end

    class FindOrCreator
      attr_reader :work_id

      def initialize(work_id, work_presenter: nil)
        @work_id = work_id
        @work_presenter = work_presenter
      end

      def find_or_create_record(retry_count: 0)
        raise StandardError, "Tried to find/create an CloudStorageArchive record too many times for work #{work_id}" if retry_count > 10

        record = CloudStorageArchive.find_by(work_id: work_id)
        if record.nil?
          record = CloudStorageArchive.create(work_id: work_id, status: :in_progress, checksum: checksum)
          RemoteArchiveJob.perform_later(record)
        end
        if disqualified?(record)
          record.delete
          record = find_or_create_record(retry_count: retry_count + 1)
        end

        return record
      rescue ActiveRecord::RecordNotUnique
        # race condition, someone else created it, no biggy
        return find_or_create_record(retry_count: retry_count + 1)
      end

      def work_presenter
        @work_presenter ||= Hyrax::GenericWorkPresenter.new(
          SolrDocument.find(work_id),
          Ability.new(nil)
        )
      end

      def checksum
        @checksum ||= Digest::MD5.hexdigest(work_presenter.public_member_presenters.map do |p|
          p.solr_document['digest_ssim'].first.delete('urn:sha1:')
        end.join('-'))
      end

      private

        def disqualified?(record)
          stalled?(record) || unrecoverable_error?(record) || checksum_mismatch?(record) || file_missing?(record)
        end

        def stalled?(record)
          record.in_progress? && (Time.current - record.updated_at) > CloudStorageArchive::STALE_IN_PROGRESS_SECONDS
        end

        def unrecoverable_error?(record)
          record.error? && (Time.current - record.updated_at) > CloudStorageArchive::ERROR_RETRY_SECONDS
        end

        def checksum_mismatch?(record)
          record.success? && record.checksum != checksum
        end

        def file_missing?(record)
          record.success? && !record.file_exists?
        end
    end

    class S3File
      attr_reader :bucket, :model

      def initialize(model, bucket_name, download_name = 'download.zip')
        @model         = model
        @bucket        = Aws::S3::Bucket.new(bucket_name)
        @download_name = download_name
      end

      def file_exists?
        bucket.object(key_path).exists?
      end

      def url
        @url ||= bucket.object(key_path).presigned_url(:get,
                                                       expires_in: 7.days.to_i,
                                                       response_content_type: 'application/zip',
                                                       response_content_disposition: encoding_safe_content_disposition(@download_name))
      end

      def write_from_path(path)
        bucket.object(key_path).upload_file(path)
      end

      protected

        def key_path
          @keypath ||= Pathname.new(model.file_name).to_s
        end

      private

        def encoding_safe_content_disposition(file_name)
          "attachment; filename=\"#{file_name.encode('US-ASCII', undef: :replace, replace: '_')}\""
        end
    end
end
