require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  get "/profile", to: "profiles#edit"
  patch "/profile", to: "profiles#update"
  put "/profile", to: "profiles#update"

  root to: "home#index"
end
