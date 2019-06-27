# Generated via
#  `rails generate hyrax:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Work'
  self.indexer = GenericWorkIndexer

  property :doi, predicate: ::RDF::Vocab::DataCite.doi, multiple: false do |index|
    index.as :stored_searchable
  end

  after_save do
    DoiMintingService.mint_identifier_for(self) if doi.nil?
  end

  before_destroy do
    DoiMintingService.tombstone_identifier_for(self) if doi.present?
  end

  include ::Hyrax::BasicMetadata
end
