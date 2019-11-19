Rails.application.routes.draw do

  resources :pages, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  resources :pages, only: [:show]
  resources :partenaires, only: [:index, :update, :edit]
  resources :partenaire_interests, only: [:create, :destroy]
  resources :memos, only: [:create, :destroy, :update]
  resources :key_date, only: [:create, :destroy, :update]
  resources :user_events, only: [:create, :destroy, :index]
end
