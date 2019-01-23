if Settings&.email&.mailer.present?
  mailer = Settings.email.mailer.to_sym
  require 'aws-sdk-rails' if mailer == :aws_sdk
  ActionMailer::Base.delivery_method = mailer
end

Hyrax::ContactForm.class_eval do
  def headers
    {
      subject: "#{Hyrax.config.subject_prefix} #{subject}",
      to: Hyrax.config.contact_email,
      from: Hyrax.config.contact_email,
      reply_to: email
    }
  end
end
