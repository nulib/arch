class DOI
  class Error < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_s
      "#{response.status} #{response.reason_phrase}\n\t#{response.body}"
    end
  end

  attr_reader :document

  delegate :client, :server_reachable?, to: :class
  delegate :attributes, :attributes=, to: :document

  TOMBSTONE_URL = 'https://www.datacite.org/invalid.html'.freeze
  PERMITTED_ATTRIBUTES = %w[
    bibtex bodyhasPid citationDoi citeproc contentType contentUrl contributors creators
    dates dcIdentifier descriptions doi downloadLatency error event firstPage formats
    fundingReferences geoLocations hasSchemaOrg identifier identifierType identifiers isActive
    issue landingPage language lastPage metadataVersion prefix publicationYear publisher
    redirectCount redirectUrls relatedIdentifiers resourceType rightsList ris schemaOrg schemaOrgid
    schemaVersion sizes source state subjects suffix title titles types url url version volume
  ].freeze
  REJECTABLE_VALUES = [nil, '', 0, [], {}].freeze

  class << self
    def client
      return nil unless configured?
      if @client.nil?
        uri_klass = (Settings.doi_credentials.use_ssl ? URI::HTTPS : URI::HTTP)
        datacite_uri = uri_klass.build(host: Settings.doi_credentials.host, port: Settings.doi_credentials.port, path: '/')
        @client = Faraday.new(url: datacite_uri).tap do |conn|
          conn.basic_auth(Settings.doi_credentials.user, Settings.doi_credentials.password)
        end
      end
      @client
    end

    def configured?
      Settings.doi_credentials.host.present?
    end

    def server_reachable?
      client.get('heartbeat').status == 200
    rescue
      false
    end
  end

  def initialize(id = nil)
    @document = Hashie::Mash.new(id: id.to_s.delete('doi:'), type: 'dois')
    reload
  end

  def id
    return nil if document.id.blank?
    ['doi', document.id].join(':')
  end

  def reload
    return if id.nil?
    load_from(client.get("dois/#{document.id}"))
  end

  def register
    attributes.prefix ||= Settings.doi_credentials.default_shoulder
    attributes.delete('event')
    load_from(client.post('dois', to_json, content_type: 'application/vnd.api+json'))
  end
  alias register! register

  def save
    load_from(client.put("dois/#{document.id}", to_json, content_type: 'application/vnd.api+json'))
  end

  def hide!
    document.id.blank? ? register : event('hide')
  end

  def publish!
    register if document.id.blank?
    event('publish')
  end

  def tombstone!
    attributes.url = TOMBSTONE_URL
    save
  end

  def to_json
    { 'data' => document }.to_json
  end

  private

    def event(state)
      attributes.event = state
      save
    end

    def load_from(response)
      raise Error, response unless response.success?
      @document = Hashie::Mash.new(JSON.parse(response.body)).data.tap do |result|
        result.delete('relationships')
        result.attributes.select! { |k, v| PERMITTED_ATTRIBUTES.include?(k) && !REJECTABLE_VALUES.include?(v) }
      end
      self
    end
end
