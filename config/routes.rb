Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  resources :pages, only: [:show]
  resources :partenaires, only: [:show, :update, :edit]
  resources :partenaire_interests, only: [:create, :destroy]
  resources :memos, only: [:create, :destroy, :update]
  resources :key_date, only: [:create, :destroy, :update]
  resources :user_events, only: [:create, :destroy, :update]
  resources :pages, only: [:show]
end
