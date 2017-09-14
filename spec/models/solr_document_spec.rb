require 'rails_helper'

describe SolrDocument do
  context 'without metadata' do
    subject { described_class.new({}) }

    describe '#title' do
      it 'returns an empty title' do
        expect(subject.title).to be_empty
      end
    end
  end

  context 'with metadata' do
    subject { described_class.new(document_hash) }

    let(:date_created) { '2017-05-14' }
    let(:system_created) { '2017-05-14T12:34:56Z' }
    let(:date_modified) { '2017-05-15T12:34:56Z' }
    let(:doi) { '10.5072/FK2GM88084' }
    let(:document_hash) do
      {
        date_created_tesim: date_created,
        system_modified_dtsi: date_modified,
        system_create_dtsi: system_created,
        language_tesim: ['eng'],
        title_tesim: ['Work Title'],
        doi_tesim: doi
      }
    end

    describe '#title' do
      it 'returns the title' do
        expect(subject.title).to eq(['Work Title'])
      end
    end

    describe '#doi' do
      it 'returns the doi' do
        expect(subject.doi).to eq('10.5072/FK2GM88084')
      end
    end
  end
end
