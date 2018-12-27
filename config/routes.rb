require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Attachinary::Engine => '/attachinary'

  root 'shop#index'

  resources :shop, only: [:index, :show]
  resources :pagarme_postback, only: :create
  resources :bradesco_check_order, only: :index

  namespace :backoffice do
    # Admin
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
      resources :social_leader_debugger, only: [:index]

      resources :product_setups, only: [:index, :show, :update]

      resources :club_motors_subscriptions, only: %i[index show]
    end

    namespace :support do
      resources :users, only: [:index, :show, :edit, :update]
      resources :documents_validation, only: [:index, :update]
    end

    namespace :installer do
      resources :dashboard, only: [:index]
      resources :product_setups, only: [:index, :show, :new, :create]
    end

    # Backoffice

    resources :dashboard, only: :index
    resource :documents, only: [:edit, :update]
    resources :downloads, only: [:index]

    resource :bank_account, only: [:edit, :update]

    # Shopping
    resources :products, only: [:index, :show]
    resource :cart, only: :show
    resource :checkout, only: :update
    resources :order_items, only: [:create, :update, :destroy]
    resources :orders, only: [:index, :show] do
      post :generate_boleto
    end
    resources :upgrades, only: [:new, :create]

    # Subscriptions
    resources :club_motors, only: %i[new create]

    namespace :club_motors do
      resources :vehicles, only: %i[index show edit update new create destroy]
      resources :monthly_fees, only: %i[index]
    end

    resources :trackers

    # Financial
    # resources :transfers, only: [:show, :update, :create]
    resources :withdrawals, only: [:index, :new, :create]
    resources :financial_entries, only: [:index]
    resources :bonus_entries, only: [:index]
    resources :pv_histories, only: [:index]
    resources :pv_activity_histories, only: [:index]
    resources :accumulated_pva, only: [:index]
    resources :pay_third_order, only: [:new, :create]

    # Network
    resources :binary_strategies, only: [:index, :create]
    resources :binary_tree, only: [:index, :show]
    resources :unilevel, only: [:index]
    resources :pv_generations_history, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: :non do
        collection do
          post :sign_in
          post :find_by_cpf
        end
      end
    end
  end

  devise_for(
    :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      unlocks: 'users/unlocks',
      confirmations: 'users/confirmations',
      masquerades: 'masquerades'
    }
  )
end
