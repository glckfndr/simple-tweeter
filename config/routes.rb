Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get 'home/index'

  # Why: API v1 namespace provides JWT-authenticated endpoints for mobile/SPA clients.
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }
      post 'tweets/create', to: 'tweets#create'
      get  'tweets/index',  to: 'tweets#index'
      get  'show/:id',      to: 'tweets#show'
      delete 'destroy/:id', to: 'tweets#destroy'
    end
  end

  resources :tweets, only: [:index, :create, :destroy, :edit, :update] do
    member do
      post 'like', to: 'tweets#like'
      delete 'unlike', to: 'tweets#unlike'
      post 'retweet', to: 'tweets#retweet'
      delete 'unretweet', to: 'tweets#unretweet'
    end
    # Why: comments are scoped to a tweet, so nested routes keep ownership explicit.
    resources :comments, only: [:create, :destroy]
  end
  resources :users, only: [:show] do
    member do
      post 'follow', to: 'users#follow'
      delete 'unfollow', to: 'users#unfollow'
      get 'followees', to: 'users#followees'
    end
  end
  get '/*path' => 'home#index', constraints: ->(req) { !req.xhr? && req.format.html? }
end
