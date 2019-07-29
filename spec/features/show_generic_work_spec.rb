require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Display a musical work' do
  let(:work) do
    GenericWork.new.tap do |work|
      work.creator = ['Creator 1']
      work.title = ['work title']
      work.doi = 'test_doi'
      work.apply_depositor_metadata('user')
      work.visibility = 'open'
      work.save
    end
  end

  context 'with a public work' do
    it 'displays all the fields' do
      visit(hyrax_generic_work_path(work.id))
      expect(page).to have_content('Creator 1')
      expect(page).to have_content('work title')
      expect(page).to have_content('https://doi.org/test_doi')
    end
  end
end
