# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe Hyrax::GenericWorkPresenter do
  context 'with a doi' do
    let(:solr_document) { SolrDocument.new(attributes) }
    let(:request) { nil }

    let(:attributes) do
      { 'id' => '888888',
        'title_tesim' => ['work title'],
        'creator_tesim' => ['Creator 1'],
        'human_readable_type_tesim' => ['Generic Work'],
        'has_model_ssim' => ['GenericWork'],
        'date_created_tesim' => ['an unformatted date'],
        'depositor_tesim' => 'a_user_key',
        'doi_tesim' => ['test_doi'] }
    end
    let(:ability) { nil }
    let(:presenter) { described_class.new(solr_document, ability, request) }

    describe '#title' do
      it 'returns the title' do
        expect(presenter.title).to eq(['work title'])
      end
    end

    describe '#creator' do
      it 'returns the creator' do
        expect(presenter.creator).to eq(['Creator 1'])
      end
    end

    describe '#doi' do
      it 'returns the doi' do
        expect(presenter.doi).to eq('test_doi')
      end
    end
  end

  context 'without a doi' do
    let(:solr_document) { SolrDocument.new(attributes) }
    let(:request) { nil }

    let(:attributes) do
      { 'id' => '888888',
        'title_tesim' => ['work title'],
        'creator_tesim' => ['Creator 1'],
        'human_readable_type_tesim' => ['Generic Work'],
        'has_model_ssim' => ['GenericWork'],
        'date_created_tesim' => ['an unformatted date'],
        'depositor_tesim' => 'a_user_key' }
    end
    let(:ability) { nil }
    let(:presenter) { described_class.new(solr_document, ability, request) }

    describe 'when doi is empty' do
      it 'returns nil (and not an error)' do
        expect(presenter.doi).to be_nil
      end
    end
  end
end
