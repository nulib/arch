# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Hyrax::DatasetPresenter do
  let(:dataset) { FactoryBot.create(:dataset, num_images: 2) }
  let(:presenter) { described_class.new(dataset.to_solr, nil, nil) }

  describe '#total_file_size' do
    before do
      allow_any_instance_of(FileSet).to receive(:file_size).and_return(['5000000'])
    end

    it 'sums the file sizes associated with a dataset into a human-readable string' do
      expect(presenter.total_file_size).to eq('9.54 MB')
    end
  end
end
