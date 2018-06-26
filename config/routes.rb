require 'sidekiq/web'

Rails.application.routes.draw do
  mount BrowseEverything::Engine => '/browse'

  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, skip: [:sessions], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, format: false
  devise_scope :user do
    get '/users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get '/users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    match '/users/auth/:provider', to: 'users/omniauth_callbacks#user', as: :user_omniauth_authorize, via: [:get, :post]
    match '/users/auth/:action/callback', controller: 'users/omniauth_callbacks', as: :user_omniauth_callback, via: [:get, :post]
  end
  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine => '/'
  mount Hydra::RoleManagement::Engine => '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'rights' => 'hyrax/pages#show', id: 'rights_page'

  get '/concern/generic_works/:id/zip', to: 'cloud_storage_archives#zip', as: :download_all
end
