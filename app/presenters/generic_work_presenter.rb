class GenericWorkPresenter < Hyrax::WorkShowPresenter
  delegate :doi, to: :solr_document

  def public_member_presenters
    @public_member_presenters ||= file_set_presenters.find_all do |m|
      m.solr_document['visibility_ssi'] == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
