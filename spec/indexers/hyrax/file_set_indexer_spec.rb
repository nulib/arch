
# frozen_string_literal: true

require 'rails_helper'

describe Hyrax::FileSetIndexer do
  let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  let(:solr_doc) { described_class.new(file_set).generate_solr_document }

  let(:file_set) { FactoryBot.create(:file_set, visibility: visibility) }

  before do
    allow(file_set).to receive(:visibility).and_return(visibility)
  end

  describe '#generate_solr_document' do
    it 'indexes the visibility' do
      expect(solr_doc['visibility_ssi']).to eq(visibility)
    end
  end
end
