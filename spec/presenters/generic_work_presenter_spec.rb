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

  describe '#title' do
    it 'returns the title' do
      expect(subject.title).to eq(["work title"])
    end
  end

  describe '#creator' do
    it 'returns the creator' do
      expect(subject.creator).to eq(["Creator 1"])
    end
  end

  describe '#doi' do
    it 'returns the doi' do
      expect(subject.doi).to eq(["test doi"])
    end
  end
end