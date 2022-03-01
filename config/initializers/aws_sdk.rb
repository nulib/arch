if Settings.localstack
  require 'aws-sdk-s3'

  Aws.config.update(
    endpoint: Settings.aws.endpoint,
    access_key_id: 'fake',
    secret_access_key: 'fake',
    force_path_style: true,
    region: 'us-east-1'
  )
end
