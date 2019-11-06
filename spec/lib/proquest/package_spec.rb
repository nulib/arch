require 'rails_helper'

RSpec.describe Proquest::Package do
  let(:zip) { "#{file_fixture_path}/proquest/etdadmin_upload_1111_embargo_code_1.zip" }
  let(:package) { Aws::S3::Object.new(client: Aws::S3::Client.new, bucket_name: Settings.aws.buckets.proquest, key: File.basename(zip)) }

  before do
    User.find_or_create_by(username: 'registered')
    package.upload_file(zip)
  end

  # rubocop:disable Layout/MultilineMethodCallIndentation
  describe '#ingest' do
    it 'creates a work and associated file_sets' do
      expect { described_class.new(package).ingest }.to change { GenericWork.count }.by(1)
        .and change { FileSet.count }.by(1)
        .and change { Hydra::AccessControls::Embargo.count }.by(2)
    end
  end
end
