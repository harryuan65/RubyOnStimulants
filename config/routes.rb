Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions:"users/sessions" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'download', controller:'application', action:'download'
  get 'delete', controller:'application', action:'delete'
  post 'post_test', controller:'application', action:'post_test'

  scope :controller=>"home",:path=>"/", :as=>"home" do
    get '/'=>:index
    get 'post_newrecord'=>:post_newrecord
    get 'list_home'=>:list_home
    post 'post_list'=>:post_list
    get 'yeah'=>:yeah
    get 'test'=>:test
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

  scope :controller=>"to_dos",:path=>"/todos", :as=>"todos" do
    get '/'=>:index
    post 'add_todo'=>:add_todo
    post 'edit_todo'=>:edit_todo
    post 'delete_todo'=>:delete_todo
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
