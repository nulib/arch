class ProquestIngestBucketJob < ApplicationJob
  # @param [Aws::S3::Bucket] bucket
  def perform(bucket)
    bucket.objects.each do |obj|
      ProquestIngestPackageJob.perform_later(bucket.name, obj.key) if obj.key.ends_with?('.zip') && !obj.key.starts_with?('_completed/')
    end
    true
  rescue StandardError => e
    Rails.logger.error e
  end
end
