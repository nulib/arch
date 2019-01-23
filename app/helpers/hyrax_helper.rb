module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def truncated_summary(options)
    options[:value].map! { |val| val.truncate_words(50) }

    iconify_auto_link(options)
  end
end
