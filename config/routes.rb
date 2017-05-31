Rails.application.routes.draw do

  root 'pages#index'

  namespace :backoffice do
    resources :careers
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
