require 'rails_helper'

RSpec.describe WorkZipCreator do
  before do
    allow(Hydra::Works::CharacterizationService).to receive(:run).and_return(nil)
  end

  let(:callback_spy) { instance_spy('callback') }
  let!(:work) { FactoryBot.create(:work, num_images: 2) }

  # rubocop:disable RSpec/ExampleLength
  it 'zips members of a work' do
    creator = described_class.new(work.id)
    zip_file = creator.create_zip

    found_entries = []
    Zip::File.open(zip_file.path) do |zip|
      expect(zip.comment).to include 'Northwestern University Libraries'

      zip.each do |entry|
        found_entries << { name: entry.name, size: entry.size }
      end
    end

    expect(found_entries.size).to eq 3
    expect(found_entries.find { |e| e[:name] == 'about.txt' }).not_to be nil

    cleanup(zip_file)
  end
  # rubocop:enable RSpec/ExampleLength

  it 'only includes \'open\' files' do
    file_set = work.file_sets.first
    file_set.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    file_set.save!
    zip_file = described_class.new(work.id).create_zip

    expect(Zip::File.open(zip_file.path).entries.count).to eq(2)
  end

  it 'updates progress with an optional callback' do
    zip_file = described_class.new(work.id).create_zip(callback: callback_spy)

    expect(callback_spy).to have_received(:call).with(progress_total: 2, progress_i: 1)
    expect(callback_spy).to have_received(:call).with(progress_total: 2, progress_i: 2)
    expect(callback_spy).not_to have_received(:call).with(progress_total: 2, progress_i: 3)

    cleanup(zip_file)
  end

  private

    def cleanup(zip_file)
      zip_file.close
      zip_file.unlink
    end
end
