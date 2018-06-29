if Settings&.email&.mailer.present?
  require 'aws-sdk-rails' if Settings.email.mailer.to_sym == :aws_sdk
  ActionMailer::Base.delivery_method = Settings.email.mailer
end
