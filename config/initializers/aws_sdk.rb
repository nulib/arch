if Settings.aws&.s3
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
end

if Settings.aws&.sqs
  require 'aws-sdk-sqs'

  Aws.config.update(
    sqs: {
      endpoint: Settings.aws.sqs.endpoint,
      region: 'us-east-1'  
    }
  )
end
