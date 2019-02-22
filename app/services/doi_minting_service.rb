class DoiMintingService
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  attr_reader :work

  EZID_MAP = {
    'Audio' =>          'Sound',
    'Book' =>           'Text',
    'Dataset' =>        'Dataset',
    'Dissertation' =>   'Text',
    'Image' =>          'Image',
    'Article' =>        'Text',
    'Masters Thesis' => 'Text',
    'Part of Book' =>   'Text',
    'Poster' =>         'Text',
    'Report' =>         'Text',
    'Research Paper' => 'Text',
    'Video' =>          'Audiovisual',
    'Software or Program Code' => 'Software'
  }.freeze

  def self.mint_identifier_for(work)
    DoiMintingService.new(work).run
  end

  def self.tombstone_identifier_for(work)
    DoiMintingService.new(work).tombstone
  end

  def initialize(obj)
    @work = obj
  end

  def run
    return unless identifier_server_reachable?
    if work.doi.present?
      update_metadata
    else
      mint_doi
    end
  end

  def tombstone
    return unless identifier_server_reachable?
    tombstone_identifier if work.doi.present?
  end

  private

    def tombstone_identifier
      identifier = minter.find(work.doi)
      identifier.status = Ezid::Status::UNAVAILABLE
      identifier.save
    end

    def update_metadata
      return if minter_user == 'apitest'
      minter.modify(work.doi, metadata)
    end

    def mint_doi
      work.doi = minter.mint(metadata).id
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
      EZID_MAP.keys.include?(work.resource_type.first) ? EZID_MAP.fetch(work.resource_type.first) : 'Other'
    end

    def url
      polymorphic_url(work, host: Settings.arch.host)
    end
end
