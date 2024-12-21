Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get 'home/index'
  resources :tweets, only: [:index, :create, :destroy, :edit, :update] do
    member do
      post 'like', to: 'tweets#like'
      delete 'unlike', to: 'tweets#unlike'
    end
  end
  resources :users, only: [:show] do
    member do
      post 'follow', to: 'users#follow'
      delete 'unfollow', to: 'users#unfollow'
      get 'followees', to: 'users#followees'
    end
  end
end
