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
end
