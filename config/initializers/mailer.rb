if Settings&.email&.mailer.present?
  mailer = Settings.email.mailer.to_sym
  require 'aws-sdk-rails' if mailer == :aws_sdk
  ActionMailer::Base.delivery_method = mailer
end
