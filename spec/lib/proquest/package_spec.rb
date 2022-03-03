require 'rails_helper'

RSpec.describe Proquest::Package do
  let(:package) { Aws::S3::Object.new(client: Aws::S3::Client.new, bucket_name: Settings.aws.buckets.proquest, key: File.basename(zip)) }

  before do
    AdminSet.find_or_create_default_admin_set_id
    User.find_or_create_by(username: 'registered')
    package.upload_file(zip)
  end

  describe '#ingest' do
    context 'when DISS_access_option is open' do
      let(:zip) { "#{file_fixture_path}/proquest/etdadmin_upload_0000_embargo_code_0.zip" }
      let(:package) { Aws::S3::Object.new(client: Aws::S3::Client.new, bucket_name: Settings.aws.buckets.proquest, key: File.basename(zip)) }

      it 'creates an open work and associated open file_sets' do
        work = described_class.new(package).ingest
        expect(work.visibility).to eq 'open'
        expect(work.file_sets.all? { |fs| fs.visibility == 'open' }).to be(true)
      end
    end

    context 'when DISS_access_option campus use only' do
      let(:zip) { "#{file_fixture_path}/proquest/etdadmin_upload_0000_embargo_code_0_campus_only.zip" }

      it 'creates an open work and associated authenticated file_sets' do
        work = described_class.new(package).ingest
        expect(work.visibility).to eq 'open'
        expect(work.file_sets.all? { |fs| fs.visibility == 'authenticated' }).to be(true)
      end
    end

    context 'when there is an embargo' do
      let(:zip) { "#{file_fixture_path}/proquest/etdadmin_upload_1111_embargo_code_1.zip" }

      it 'creates an open work and associated open file_sets' do
        work = described_class.new(package).ingest
        expect(work.visibility).to eq 'restricted'
        expect(work.file_sets.all? { |fs| fs.visibility == 'restricted' }).to be(true)
      end
    end
  end
end
