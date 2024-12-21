Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get 'home/index'
  resources :tweets, only: [:index, :create, :destroy, :edit, :update]
end
