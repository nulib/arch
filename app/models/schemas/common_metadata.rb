# frozen_string_literal: true

module Schemas
  ##
  # Schema for metadata shared among Work types
  #
  # @example applying the common metadata schema
  #
  #   class WorkType < ActiveFedora::Base
  #     include ::Hyrax::WorkBehavior
  #     include ::Schemas::CommonMetadata
  #     include ::Hyrax::BasicMetadata
  #   end
  #
  # @see ActiveFedora::Base
  # @see Hyrax::WorkBehavior
  module CommonMetadata
    extend ActiveSupport::Concern

    included do
      property :doi, predicate: ::RDF::Vocab::DataCite.doi, multiple: false do |index|
        index.as :stored_searchable
      end
    end
  end
end
