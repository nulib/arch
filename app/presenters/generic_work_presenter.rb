class GenericWorkPresenter < Hyrax::WorkShowPresenter
  delegate :doi, to: :solr_document # rubocop:disable Metrics/LineLength
end