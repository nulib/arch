require 'rails_helper'

RSpec.describe CloudStorageArchive do
  let(:work) { FactoryBot.create(:work) }
  let(:sample_file_path) { "#{file_fixture_path}/coffee.jpg" }
  let(:bucket) { Aws::S3::Bucket.new(Settings.aws.buckets.archives) }

  context 'uploads files to S3' do
    let(:instance) { described_class.create(work_id: work.id, checksum: 'fake_checksum') }

    describe '.write_from_path' do
      it 'writes to store' do
        instance.write_from_path(sample_file_path)
        expect(bucket.objects.count).to eq 1
      end

      it 'has a url' do
        expect(instance.url).to start_with('https://')
      end
    end
  end

  context 'uses previously created archive if possible' do
    describe '#find_or_create_record' do
      it 'creates if archive is not found or there is a problem' do
        expect { described_class.find_or_create_record(work.id) }.to have_enqueued_job(RemoteArchiveJob).once
      end

      it 'returns an archive if it is found' do
        expect do
          described_class.find_or_create_record(work.id)
          described_class.find_or_create_record(work.id)
        end.to have_enqueued_job(RemoteArchiveJob).once
      end
    end
  end
end
