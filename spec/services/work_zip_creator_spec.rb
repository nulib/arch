require 'rails_helper'

RSpec.describe WorkZipCreator do
  before do
    allow(Hydra::Works::CharacterizationService).to receive(:run).and_return(nil)
  end

  let!(:work) do
    work = FactoryBot.create(:work, num_images: 2)
    child_work = FactoryBot.create(:work)
    work.members << child_work
    work.ordered_members << child_work
    work.save!
    child_work.save!

    work
  end

  # rubocop:disable RSpec/ExampleLength
  it 'zips members of a work' do
    creator = described_class.new(work.id)
    zip_file = creator.create_zip

    found_entries = []
    Zip::File.open(zip_file.path) do |zip_file|
      expect(zip_file.comment).to include 'Northwestern University Libraries'

      zip_file.each do |entry|
        found_entries << { name: entry.name, size: entry.size }
      end
    end

    expect(found_entries.size).to eq 3
    expect(found_entries.find { |e| e[:name] == 'about.txt' }).not_to be nil

    zip_file.close
    zip_file.unlink
  end
  # rubocop:enable RSpec/ExampleLength
end
