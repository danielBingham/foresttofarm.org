Rails.application.routes.draw do

  root 'plants#index'

  resources :plants, only: [:index, :show]

  namespace :api do
    namespace :v0 do
      resources :plants, only: [:index, :show]
    end
  end

end
