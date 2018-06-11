class GenericWorkPresenter < Hyrax::WorkShowPresenter
  delegate :doi, to: :solr_document
end
