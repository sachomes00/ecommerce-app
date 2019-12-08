Rails.application.routes.draw do
  get 'stripe_webhooks/create'
  root 'products#index'

  resources :products, only: :index
  resources :orders, only: [:new, :show, :create]
  resources :line_items, only: [:create, :update, :destroy, :show]
  resources :shopping_carts, only: [:show, :destroy]

  post 'stripe/webhook', to: 'stripe_webhooks#create'
end
