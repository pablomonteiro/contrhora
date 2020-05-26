Rails.application.routes.draw do

  scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do

    root 'home#index'

    resources :records
    namespace :admin do
      resources :users
      resources :records, only: [:index]
    end
    resources :user_sessions, :only => [:create, :new, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
