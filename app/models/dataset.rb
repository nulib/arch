# Generated via
#  `rails generate hyrax:work Dataset`
class Dataset < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Schemas::CommonMetadata
  include DoiMintable

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  after_initialize :default_values

  self.indexer = DatasetIndexer
  DEFAULT_PUBLISHER = 'Northwestern University'.freeze
  DEFAULT_RESOURCE_TYPE = Qa::Authorities::Local.subauthority_for('resource_types').find('Dataset').fetch('id').freeze

  property :contact_information, predicate: ::RDF::Vocab::DCAT.contactPoint do |index|
    index.as :stored_searchable
  end

  property :related_citation, predicate: ::RDF::Vocab::DC.references do |index|
    index.as :stored_searchable
  end

  include ::Hyrax::BasicMetadata

  apply_schema Schemas::CoreMetadata, Schemas::GeneratedResourceSchemaStrategy.new

  def default_values
    publisher << DEFAULT_PUBLISHER
    resource_type << DEFAULT_RESOURCE_TYPE
  end
end
