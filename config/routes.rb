Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  resources :products, only: :index
  resources :orders, only: [:new, :show, :create]
  resources :line_items, only: [:create, :update, :destroy, :show]
  resources :shopping_carts, only: [:show, :destroy]
  post '/stripe/webhook', to: 'stripe_webhook#create'
end
