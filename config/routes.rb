Rails.application.routes.draw do
  resources :pages, only: [:index]
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :pages, only: [:show]
  resources :partenaires, only: [:index, :update, :edit]
  resources :partenaire_interests, only: [:create, :destroy]
  resources :memos, only: [:create, :destroy, :update]
  resources :key_date, only: [:create, :destroy, :update]
  resources :user_events, only: [:create, :destroy, :index]
end
