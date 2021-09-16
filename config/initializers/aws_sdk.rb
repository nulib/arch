if Settings.localstack
  require 'aws-sdk-s3'

  Aws.config.update(
    endpoint: Settings.aws.endpoint,
    access_key_id: 'minio',
    secret_access_key: 'minio123',
    force_path_style: true,
    region: 'us-east-1'
  )
end
