# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    def doi
      "https://doi.org/#{solr_document.doi.first.split(':').last}" unless solr_document.doi.empty?
    end

    def public_member_presenters
      @public_member_presenters ||= file_set_presenters.find_all do |m|
        m.solr_document['visibility_ssi'] == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    def universal_viewer?
      representative_id.present? &&
        representative_presenter.present? &&
        representative_presenter.image? &&
        Hyrax.config.iiif_image_server? &&
        members_include_viewable_image?
    end
  end
end
