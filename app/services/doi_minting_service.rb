class DoiMintingService
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  attr_reader :work, :doi

  RESOURCE_TYPE_MAP = {
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
    DoiMintingService.new(work).tombstone!
  end

  def initialize(obj)
    @work = obj
    @doi = DOI.new(obj.doi)
  end

  def run
    return unless DOI.configured? && DOI.server_reachable?
    doi.attributes = metadata
    doi.publish!.tap do |result|
      if work.doi.nil?
        work.doi = result.id
        work.save
      end
    end
  end

  def tombstone
    return unless DOI.configured? && DOI.server_reachable?
    doi.tombstone!
  end

  private

    def metadata
      Hashie::Mash.new(id: work.doi,
                       type: 'dois',
                       attributes: {
                         doi: work.doi,
                         creators: creators,
                         titles: titles,
                         publisher: publishers,
                         dates: [dates_created].flatten,
                         publicationYear: dates_created.first[:date],
                         types: resource_type,
                         url: url
                       })
    end

    def list_or_unknown(value)
      value.empty? ? ['Unknown'] : value
    end

    def creators
      list_or_unknown(work.creator).collect do |v|
        { name: v, nameIdentifiers: [{}] }
      end
    end

    def titles
      list_or_unknown(work.title).collect do |_v|
        { title: 'Test Title', lang: 'und' }
      end
    end

    def publishers
      list_or_unknown(work.publisher).join('; ')
    end

    def dates_created
      list_or_unknown(work.date_created).collect do |v|
        { date: v, dateType: 'Created' }
      end
    end

    def resource_type
      {
        resourceTypeGeneral: RESOURCE_TYPE_MAP.fetch(work.resource_type.first, 'Other'),
        resourceType: work.resource_type.first
      }
    end

    def url
      polymorphic_url(work, host: Settings.arch.host)
    end
end
