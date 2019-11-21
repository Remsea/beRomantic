Rails.application.routes.draw do

  root to: 'pages#home'
  resources :pages, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :pages, only: [:show]
  resources :partenaires, only: [:index, :update, :edit]
  resources :partenaire_interests, only: [:create, :destroy]
  resources :memos, only: [:create, :destroy, :update]
  resources :key_dates, only: [:create, :destroy, :update]
  resources :user_events, only: [:create, :destroy, :index]
  post '/ajax/users', to: 'user_services#update_user_ajax', as: 'ajax_user'
end
