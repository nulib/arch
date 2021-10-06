# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require 'aws-sdk-s3'

  Aws.config.update(
    s3: {
      endpoint: Settings.aws.s3.endpoint,
      access_key_id: 'minio',
      secret_access_key: 'minio123',
      force_path_style: true,
      region: 'us-east-1'
    }
  )

  namespace :s3 do
    desc 'Create buckets'
    task :setup do
      Settings.aws.buckets.to_h.values.each do |bucket|
        bucket = Aws::S3::Bucket.new(bucket)
        bucket.create unless bucket.exists?
      end
    end

    desc 'Empty S3 buckets'
    task empty_buckets: :environment do
      Settings.aws.buckets.to_h.values.each do |bucket|
        bucket = Aws::S3::Bucket.new(bucket)
        bucket.objects.each(&:delete)
      end
    end

    desc 'Delete S3 buckets'
    task delete_buckets: :environment do
      Settings.aws.buckets.to_h.values.each do |bucket|
        Aws::S3::Client.new.delete_bucket(bucket: bucket)
      end
    end

    desc 'Empty and delete S3 buckets'
    task :teardown do
      Rake::Task['s3:empty_buckets'].invoke
      Rake::Task['s3:delete_buckets'].invoke
    end
  end
end
