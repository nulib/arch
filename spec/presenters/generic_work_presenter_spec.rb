require 'rails_helper'

describe GenericWorkPresenter do
  let(:work) do
    GenericWork.new.tap do |work|
      work.id = "work-id"
      work.creator = ["Creator 1"]
      work.title = ["work title"]
      work.doi = "test doi"
    end
  end

  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:ability)       { Ability.new(nil) }
  let(:request)       { nil }

  subject { described_class.new(solr_document, ability, request) }

  its(:title) { is_expected.to eq(["work title"]) }
  its(:creator) { is_expected.to eq(["Creator 1"]) }
  its(:doi) { is_expected.to eq(["test doi"]) }
end