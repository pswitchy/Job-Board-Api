Rails.application.routes.draw do
  # Websockets
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'

      resources :jobs, only: [:index, :show, :create, :update, :destroy] do
        post 'apply', to: 'applications#create'
      end

      resources :companies
      resources :profiles
      
      get 'employer/applications', to: 'applications#index_employer'
      patch 'applications/:id/status', to: 'applications#update_status'
    end
  end
end