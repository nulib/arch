class GenericWork < Hyrax::Work
  include Hyrax::Schema(:generic_work)
  include Hyrax::Schema(:basic_metadata)

  # TODO: Replace these hooks with changesets?
  # after_save do
  #   DoiMintingService.mint_identifier_for(self) if doi.nil?
  # end

  # before_destroy do
  #   DoiMintingService.tombstone_identifier_for(self) if doi.present?
  # end
end
