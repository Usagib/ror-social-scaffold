Rails.application.routes.draw do

  root 'posts#index'
  get '/friendships', to: 'friendships#index'
  patch '/friendships', to: 'friendships#confirm', as: 'confirm'
  delete '/friendships', to: 'friendships#destroy', as: 'unfriend'

  devise_for :users

  resources :users, only: [:index, :show] do
    resources :friendships, only: [:create, :index]
  end
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
