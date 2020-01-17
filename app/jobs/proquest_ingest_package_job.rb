class ProquestIngestPackageJob < ApplicationJob
  # @param [String] bucket_name
  # @param [String] key

  def perform(bucket_name, key)
    return unless key.ends_with?('.zip')
    obj = Aws::S3::Object.new(bucket_name, key)
    Proquest::Package.new(obj).ingest
  rescue StandardError => e
    Rails.logger.error e
  end
end
