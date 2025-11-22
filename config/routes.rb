Rails.application.routes.draw do
  # Swagger API documentation
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1 routes
  namespace :api do
    namespace :v1 do
      # User Authentication
      post "users/register", to: "users#register"
      post "users/login", to: "users#login"

      # Lessons
      get "lessons", to: "lessons#index"
      get "lessons/:id", to: "lessons#show"
      post "lessons", to: "lessons#create"

      # User Lessons (enrollment)
      post "user_lessons", to: "user_lessons#create"
      get "user_lessons/:id", to: "user_lessons#show"

      # Recordings
      post "recordings", to: "recordings#create"
      get "recordings/:id", to: "recordings#show"

      # Analysis
      post "analysis", to: "analysis#create"
      get "analysis/:id", to: "analysis#show"

      # Avatar (HeyGen)
      post "avatar/speak", to: "avatar#speak"
    end
  end

  # Legacy routes (deprecated - kept for backward compatibility)
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'
  get '/lessons', to: 'lessons#index'
  post '/recordings', to: 'recordings#create'
  get '/recordings/:id', to: 'recordings#show'
  post '/recordings/:id/analyze', to: 'recordings#analyze'
  get '/voices', to: 'voices#index'
end
