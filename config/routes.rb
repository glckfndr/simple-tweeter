Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'tweets/index'
      post 'tweets/create'
      get '/show/:id', to: 'tweets#show'
      delete '/destroy/:id', to: 'tweets#destroy'
    end
  end

  root 'homepage#index'
  get '/*path' => 'homepage#index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
