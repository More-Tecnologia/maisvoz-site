Rails.application.routes.draw do

  root 'pages#index'

  namespace :backoffice do
    namespace :admin do
      resources :careers, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :products, only: [:index, :new, :create, :edit, :update, :destroy]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
