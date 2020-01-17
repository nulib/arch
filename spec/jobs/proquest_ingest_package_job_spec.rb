require 'rails_helper'

RSpec.describe ProquestIngestPackageJob, type: :job do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform_later' do
    it 'enqueues jobs' do
      expect do
        described_class.perform_later('1234')
      end.to have_enqueued_job
    end
  end
end
