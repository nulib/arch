RSpec.shared_examples 'doi mintable' do
  context 'doi minting' do
    before do
      stub_request(:get, 'datacite-test.example.org/heartbeat').to_return(status: 200, body: 'OK')

      stub_request(:post, 'datacite-test.example.org/dois')
        .with(basic_auth: ['arch-test-user', 'arch-test-pass'])
        .to_return(status: 200, headers: { content_type: 'application/json' }, body: file_fixture('datacite_response.json').read)

      stub_request(:put, 'datacite-test.example.org/dois/10.21985/N2-abcd-1234')
        .with(basic_auth: ['arch-test-user', 'arch-test-pass'])
        .to_return(status: 200, headers: { content_type: 'application/json' }, body: file_fixture('datacite_response.json').read)
    end

    let(:model) do
      described_class.create(title: ['title'])
    end

    it 'creates a doi after a save' do
      expect(model.doi).to start_with('doi')
    end

    it 'tombstones a doi when the model is destroyed' do
      allow(DoiMintingService).to receive(:tombstone_identifier_for)
      model.destroy
      expect(DoiMintingService).to have_received(:tombstone_identifier_for)
    end
  end
end
