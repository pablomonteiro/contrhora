Rails.application.routes.draw do

  get '', to: redirect("/#{I18n.locale}")

  scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do

    root 'home#index'

    resources :records
    resources :users, only: [] do
      get 'change_password', on: :member
      patch 'update_password', on: :member
    end
    namespace :admin do
      resources :users do
        patch 'activate', on: :member
        patch 'deactivate', on: :member
      end
      resources :records, only: [:index]
    end
    resources :user_sessions, :only => [:create, :new, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
