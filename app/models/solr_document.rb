# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.
  use_extension(Hydra::ContentNegotiation)

  def alternate_identifier
    fetch(Solrizer.solr_name('alternate_identifier', :stored_searchable), [])
  end

  def bibliographic_citation
    fetch(Solrizer.solr_name('bibliographic_citation', :stored_searchable), [])
  end

  def contact_information
    fetch(Solrizer.solr_name('contact_information', :stored_searchable), [])
  end

  def doi
    fetch(Solrizer.solr_name('doi', :stored_searchable), [])
  end

  def related_citation
    fetch(Solrizer.solr_name('related_citation', :stored_searchable), [])
  end
end
