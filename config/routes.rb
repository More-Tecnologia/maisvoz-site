require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Attachinary::Engine => "/attachinary"

  root 'shop#index'

  resources :shop, only: [:index, :show]

  namespace :backoffice do
    namespace :admin do
      # Shopping Admin
      resources :careers, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :products, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :orders, only: [:index, :show] do
        post :approve
      end

      # Financial Admin
      resources :credits_debits, only: [:show, :update, :create]
      resources :financial_entries, only: [:index]
      resources :withdrawals, only: [:index, :update]
      resources :bonus_entries, only: [:index]
      resources :pv_activity_histories, only: [:index]
      resources :pv_histories, only: [:index]
      resources :accumulated_pva, only: [:index]
      resources :career_histories, only: [:index]

      # Admin
      resources :users, only: [:index, :show]
    end

    namespace :support do
      resources :documents_validation, only: [:index, :update]
    end

    resources :dashboard, only: :index
    resource :documents, only: [:edit, :update]
    resources :downloads, only: [:index]

    resource :bank_account, only: [:edit, :update]

    # Shopping
    resources :products, only: [:index, :show]
    resource :cart, only: :show
    resource :checkout, only: :update
    resources :order_items, only: [:create, :update, :destroy]
    resources :orders, only: [:index, :show]

    # Financial
    # resources :transfers, only: [:show, :update, :create]
    resources :withdrawals, only: [:index, :new, :create]
    resources :financial_entries, only: [:index]
    resources :bonus_entries, only: [:index]
    resources :pv_histories, only: [:index]
    resources :pv_activity_histories, only: [:index]
    resources :accumulated_pva, only: [:index]

    # Network
    resources :binary_strategies, only: [:index, :create]
    resources :binary_tree, only: [:index, :show]
    resources :unilevel, only: [:index]
    resources :pv_generations_history, only: [:index]

  end

  devise_for(
    :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      unlocks: 'users/unlocks',
      masquerades: 'masquerades'
    }
  )

end
