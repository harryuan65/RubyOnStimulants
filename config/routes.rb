Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions:"users/sessions", registrations: "users/registrations" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'download', controller:'application', action:'download'
  get 'delete', controller:'application', action:'delete'
  post 'post_test', controller:'application', action:'post_test'
  get 'err', controller:'application', action:'err'
  get 'privacy_policy', controller: 'home', action: 'privacy_policy'
  post 'cancel_fb_authorization', controller: 'application', action: 'dev_cancel_fb'
  get 'poke', to: 'application#poke'
  get 'google3e784468cd0fd9bb.html', controller: 'home', action: 'domain_auth'
  scope :controller=>"home",:path=>"/", :as=>"home" do
    get 'news'=>:index
    get 'post_newrecord'=>:post_newrecord
    get 'list_home'=>:list_home
    post 'post_list'=>:post_list
    get 'yeah'=>:yeah
    get 'test'=>:test
    post 'webhook'=>:webhook
  end

  resources :accounts, controller: 'accounts' do
    collection do
      get :index
      get :new
      post :add
      get :all
      get :show_day
      post :delete
      get :report
    end
  end

  resources :to_do_lists do
    resources :to_do_items do
      member do
        post :update_position
      end
    end
  end

  scope :controller => "excel", :path => "/excel", :as => "excel" do
    # get 'meetings/:id' => :show, :as => "meeting"
    get '/' => :index
    post '/upload' => :upload
    get '/show_csv' => :show_csv
    get '/processed_csv' => :processed_csv
    get '/export_filter_africa' => :export_filter_africa
  end

  scope :controller => "line", :path=> "/line", :as=>"line" do
    post '/webhook' => :webhook
  end

  resources :supplies, :controller=>'supplies' do
    collection do
      get '/all' => :all
    end
  end

  resources :articles do
    collection do
      get :search, to: redirect("/")
      post :search
      get :backup_settings
      post :backup
      get :mine
      post :preview_markdown
      get :hot
      get :cached_hot
      get :get_link_title
    end
    member do
      put :update_state
    end
  end

  resources :words, :controller=>'words' do
  end

  match '*unmatched', to: 'application#route_not_found', via: :all
end
