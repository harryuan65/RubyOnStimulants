Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions:"users/sessions" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'post_newrecord', controller: 'home', action:'post_newrecord'
  get 'list_home',controller:'home', action:'list_home'
  post 'post_list',controller:'home', action:'post_list'
  resources :accounts, controller: 'accounts' do
    collection do
      get :index
      get :new
      post :add
      get :all
      get :report
    end
    member do

    end
  end
end
