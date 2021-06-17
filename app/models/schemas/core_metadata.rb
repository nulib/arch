module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :license, predicate: ::RDF::Vocab::DC.license
  end
end
