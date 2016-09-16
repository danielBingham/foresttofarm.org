Rails.application.routes.draw do

  root 'plants#index'

  resources :plants, only: [:index, :show], controller: 'site' do
    resources :images, only: [:index, :new, :edit, :show], controller: 'site'
  end

  namespace :api do
    namespace :v0 do
      resources :plants, only: [:index, :show] do
        resources :images, only: [ :index, :show, :create, :update, :destroy ]
      end
    end
  end

end
