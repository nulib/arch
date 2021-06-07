# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Dataset', js: false do
  context 'a logged in user' do
    let(:depositor) { FactoryBot.create(:user) }

    before do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:default]
      AdminSet.find_or_create_default_admin_set_id
      login_as depositor
    end

    scenario do
      visit '/dashboard/my/works'
      expect(page).to have_content(/add new dataset/i)
    end
  end
end
