# Generated via
#  `rails generate hyrax:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Schemas::CommonMetadata
  include DoiMintable

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  self.indexer = GenericWorkIndexer

  include ::Hyrax::BasicMetadata
end
