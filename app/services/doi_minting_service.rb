class DoiMintingService
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  attr_reader :work

  def self.mint_identifier_for(work)
    DoiMintingService.new(work).run
  end

  def initialize(obj)
    @work = obj
  end

  def run
    return unless identifier_server_reachable?
    if work.identifier.present?
      update_metadata
    else
      mint_identifier
    end
  end

  private

  def update_metadata
    return if minter_user == 'apitest'
    minter.modify(work.identifier, metadata)
  end

  def mint_identifier
    work.identifier = minter.mint(metadata).id
    work.save
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

  def creator
    return 'Unknown' if work.creator.empty?
    work.creator.join('; ')
  end

  def title
    return 'Unknown' if work.title.empty?
    work.title.join('; ')
  end

  def publisher
    return 'Unknown' if work.publisher.empty?
    work.publisher.join('; ')
  end

  def date_created
    return 'Unknown' if work.date_created.empty?
    work.date_created.join('; ')
  end

  def resource_type
    return 'Other' if work.resource_type.empty?
    work.resource_type.join('; ')
  end

  def url
    polymorphic_url(work, host: Rails.application.secrets.host || 'localhost:3333')
  end
end
