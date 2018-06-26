require 'rails_helper'

RSpec.describe RemoteArchiveJob, type: :job do
  let(:archive) { CloudStorageArchive.create(work_id: 'fake_id', checksum: 'fake_checksum') }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform_later' do
    it 'enqueues jobs' do
      expect do
        described_class.perform_later('1234')
      end.to have_enqueued_job
    end

    it 'updates the archive status on error' do
      described_class.perform_now(archive)
      expect(archive.status).to eq 'error'
      expect(archive.error_info).not_to be_empty
    end
  end
end
