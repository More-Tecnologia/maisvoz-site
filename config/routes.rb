Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root 'pages#index'

  namespace :backoffice do
    namespace :admin do
      # Shopping Admin
      resources :careers, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :products, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :orders, only: [:index, :show]

      # Financial Admin
      resources :credits_debits, only: [:new, :create]
      resources :financial_entries, only: [:index]
    end

    resources :dashboard, only: :index

    # Shopping
    resources :products, only: [:index, :show]
    resource :cart, only: :show
    resource :checkout, only: :update
    resources :order_items, only: [:create, :update, :destroy]
    resources :orders, only: [:index, :show]

    # Financial
    resources :withdrawals, only: [:new, :create]
    resources :transfers, only: [:new, :create]
    resources :financial_entries, only: [:index]
    resources :bonus_entries, only: [:index]

  end

  devise_for(
    :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  )

end
