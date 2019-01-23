# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe GenericWork do
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:depositor) }
  it { is_expected.to respond_to(:creator) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:doi) }

  context 'doi minting' do
    let(:work) do
      described_class.create(title: ['title'])
    end

    it 'creates a doi after a save' do
      expect(work.doi).to start_with('doi')
    end

    it 'tombstones a doi when the work is destroyed' do
      allow(DoiMintingService).to receive(:tombstone_identifier_for)
      work.destroy
      expect(DoiMintingService).to have_received(:tombstone_identifier_for)
    end
  end
end
