require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  describe 'GET #index' do
    it 'includes X-Frame-Options: ALLOWALL' do
      get :index
      expect(response.headers['X-Frame-Options']).to eq 'ALLOWALL'
    end

    it 'allows configured sort order' do
      get :index, params: { sort: 'date_modified_dtsi desc' }
      expect(response.status).to eq(200)
    end

    it 'returns 400 Bad Request on unconfigured sort order' do
      get :index, params: { sort: 'date_modified_dtsi desc asctests.arachni-scanner.com/rfi.md5.txt' }
      expect(response.status).to eq(400)
    end
  end
end
