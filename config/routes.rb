Rails.application.routes.draw do

  root 'home#index'

  resources :records
  namespace :admin do
    resources :users
    resources :records, only: [:index]
  end
  resources :user_sessions, :only => [:create, :new, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
