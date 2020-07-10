require 'sidekiq/web'

Rails.application.routes.draw do
  resources :profiles
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: "home#index"
end
