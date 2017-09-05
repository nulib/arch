class DoiMintingService
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  attr_reader :work, :identifier

  def self.mint_identifier_for(work)
    DoiMintingService.new(work).run
  end

  def initialize(obj)
    @work = obj
    @identifier = obj.identifier
  end

  def run
    return unless identifier_server_reachable?
    if identifier.present?
      update_metadata
    else
      mint_identifier
    end
  end

  private

    def update_metadata
      return if minter_user == 'apitest'
      minter.modify(identifier, metadata)
    end

    def minter_user
      Ezid::Client.config.user
    end

    def minter
      Ezid::Identifier
    end

    # Any error raised during connection is considered false
    def identifier_server_reachable?
      Ezid::Client.new.server_status.up?
    rescue
      false
    end

    def metadata
      {
        'datacite.creator' => creator,
        'datacite.title' => title,
        'datacite.publisher' => publisher,
        'datacite.publicationyear' => date_created,
        'datacite.resourcetype' => resource_type,
        target: url
      }
    end

    def date_created
      return 'Unknown' if work.date_created.empty?
      work.date_created.join('; ')
    end

    def creator
      return 'Unknown' if work.creator.empty?
      work.creator.join('; ')
    end

    def publisher
      return 'Unknown' if work.publisher.empty?
      work.publisher.join('; ')
    end

    def title
      return 'Unknown' if work.title.empty?
      work.title.join('; ')
    end

    def resource_type
      return 'Other' if work.resource_type.empty?
      work.resource_type.join('; ')
    end

    def url
      polymorphic_url(work, host: 'localhost:3333')
    end

    def mint_identifier
      work.identifier = [minter.mint(metadata).id]
      work.save
    end
end
