Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions:"users/sessions" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'post_newrecord', controller: 'home', action:'post_newrecord'
  get 'list_home',controller:'home', action:'list_home'
  post 'post_list',controller:'home', action:'post_list'
  get 'download', controller:'application', action:'download'
  get 'delete', controller:'application', action:'delete'
  resources :accounts, controller: 'accounts' do
    collection do
      get :index
      get :new
      post :add
      get :all
      get :delete
      get :report
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
end
