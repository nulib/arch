if Settings.localstack
  # Use localstack for AWS services
  require 'docker/stack/localstack/endpoint_stub'
  Docker::Stack::Localstack::EndpointStub.stub_endpoints!

  Aws.config.update(
    force_path_style: true,
    region: 'us-east-1'
  )

  if Settings.localstack.sqs
    require 'active_job/queue_adapters/active_elastic_job_adapter'
    Rails.application.configure do
      config.active_job.queue_adapter = :active_elastic_job
      config.active_elastic_job.process_jobs = true
      config.active_elastic_job.aws_credentials = Aws::SharedCredentials.new
      config.active_elastic_job.secret_key_base = Rails.application.secrets[:secret_key_base]
      config.middleware.use(ActiveElasticJob::Rack::SqsMessageConsumer)
    end
  end
end
