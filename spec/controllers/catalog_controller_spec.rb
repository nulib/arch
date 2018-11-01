require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  describe 'GET #index' do
    it 'includes X-Frame-Options: ALLOWALL' do
      get :index
      expect(response.headers['X-Frame-Options']).to eq 'ALLOWALL'
    end
  end
end
