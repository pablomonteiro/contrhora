Rails.application.routes.draw do
  resources :records
  resources :users

  root 'records#new'

  resources :user_sessions, :only => [:create, :new, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
