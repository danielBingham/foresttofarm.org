Rails.application.routes.draw do

  root 'site/plants#index'

  namespace :site do
    resources :plants, only: [:index, :show]
  end

  namespace :api do
    namespace :v0 do
      resources :plants, only: [:index, :show]
    end
  end

end
