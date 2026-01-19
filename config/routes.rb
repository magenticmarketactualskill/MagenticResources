Rails.application.routes.draw do
  # Authentication
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Dashboard
  root "dashboard#index"

  # Resources (talent)
  resources :resources do
    member do
      post :add_skill
      delete :remove_skill
    end
  end

  # Skills
  resources :skills

  # Teams
  resources :teams do
    member do
      post :add_member
      delete :remove_member
    end
  end

  # Projects with nested assignments
  resources :projects do
    resources :assignments, except: [:index]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
