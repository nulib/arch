module DoiMintable
  extend ActiveSupport::Concern

  included do
    after_save do
      DoiMintingService.mint_identifier_for(self) if doi.nil?
    end

    before_destroy do
      DoiMintingService.tombstone_identifier_for(self) if doi.present?
    end
  end
end
