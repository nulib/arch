module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def truncated_summary(options)
    options[:value].map! { |val| val.truncate_words(50) }

    iconify_auto_link(options)
  end

  def license_service(presenter)
    if presenter.respond_to?(:curation_concern) &&
       presenter.curation_concern.model_name.element.in?(['generic_work', 'dataset'])
      Hyrax.config.license_service_class.new("#{presenter.curation_concern.model_name.element}_licenses")
    else
      Hyrax.config.license_service_class.new
    end
  end
end
