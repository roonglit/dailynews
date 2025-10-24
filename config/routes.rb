Rails.application.routes.draw do
  # Scoped Devise routes for Members (STI)
  devise_for :members, class_name: "Member", controllers: {
    registrations: "members/registrations",
    sessions: "members/sessions"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :subscriptions, only: %i[index update]
  resource :library, only: %i[show]
  resources :cart_items, only: %i[create update]
  resource :checkout, only: %i[show create]
  resources :newspapers, only: %i[show]
  resources :orders, only: %i[create] do
    member do
      get "complete"
    end
  end

  namespace :admin do
    devise_for :users, class_name: "Admin::User", skip: [ :registrations ], controllers: {
      sessions: "admin/users/sessions",
      passwords: "admin/users/passwords"
    }

    resources :customers, only: %i[index show edit update]
    resource :subscription, only: %i[show]
    resource :overview, only: %i[show]
    resources :products
    resources :members, only: [ :index, :edit, :update ]
    resources :newspapers
    root "home#index"
  end

  # Style Guide (only accessible in development/staging)
  get "style-guide" => "style_guide#index", as: :style_guide

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  match "*path", to: redirect("/"), via: :all
end
