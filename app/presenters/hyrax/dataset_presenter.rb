# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetPresenter < Hyrax::WorkShowPresenter
    delegate :alternate_identifier, :bibliographic_citation, :contact_information, :doi, :related_citation, to: :solr_document

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

    def total_file_size
      file_size = solr_document['file_set_ids_ssim'].map do |file_set_id|
        begin
          ::FileSet.find(file_set_id)&.file_size&.first&.to_i || 0
        rescue ActiveFedora::ModelMismatch
          0
        end
      end.reduce(:+)
      ActiveSupport::NumberHelper.number_to_human_size(file_size)
    end
  end
end
