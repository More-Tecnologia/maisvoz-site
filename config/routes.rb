require 'sidekiq/web'

Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  authenticate :user, lambda {|u| u.role == "admin"} do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Attachinary::Engine => '/attachinary'

  resources :shop, only: [:index, :show]
  resources :bradesco_check_order, only: :index
  resources :maintenances, only: :index

  namespace :backoffice do
    namespace :admin do
      # Shopping Admin
      resources :careers, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :products, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :unilevel_scores, only: [:index]
      resources :binary_scores, only: [:index]
      resources :lineage_scores, only: [:index]
      resources :point_qualifications, only: [:index]
      resources :orders, only: [:index, :show] do
        post :approve
        post :mark_as_billed
      end
      resources :order_items, only: [] do
        resources :sim_cards, only: [:new, :create, :destroy]
      end
      resources :order_approver_without_bonifications, only: [:update]
      resource :sim_card_control, only: [:new]
      resources :sim_card_reports, only: [:index]
      resources :user_versions, only: [:index]

      # Financial Admin
      resources :credits_debits, only: [:show, :update, :create]
      resources :financial_transactions, only: [:index]
      resources :withdrawals, only: %i[index update]
      resources :withdrawal_approvals, only: %i[new create]
      resources :withdrawals_mailer, only: :none do
        put :send_email_confirmation
      end
      resources :pv_activity_histories, only: [:index]
      resources :pv_histories, only: [:index]
      resources :accumulated_pva, only: [:index]
      resources :career_histories, only: [:index]
      resources :cellphone_reloads, only: [:index]
      resources :pool_leaderships, only: %i[new create]
      resources :pool_trandings, only: [:new, :create]
      resources :dashboard, only: :index do
        collection do
          get :bonus_data
          get :payment_data
          get :withdrawals_data
        end
      end
      resources :expenses, only: [:new, :create]
      resources :bonus_contracts, only: :index
      resources :media_files, only: %i[show new create edit update]
      resources :financial_reports, only: %i[index update]
    end

    namespace :support do
      resources :users, only: [:index, :show, :edit, :update]
      resources :documents_validation, only: [:index, :update]
      resources :blocked_users, only: [:update]
      resources :canceled_users, only: [:update]
      resource :support_point_users, only: :create
    end

    resources :dashboard, only: :index do
      collection do
        get :balances_data
        get :binary_counts_data
        get :binary_scores_data
        get :bonus_data
        get :earnings_data
        get :unilevel_counts_data
      end
    end

    resources :deposits, only: %i[index new create] do
      collection do
        get :cart
        post :checkout
      end
    end
    resource :documents, only: [:edit, :update]
    resources :downloads, only: :index
    resources :binary_scores, only: [:index]
    resources :unilevel_scores, only: [:index]
    resources :bonus_contracts, only: [:index, :show]
    resources :financial_transactions, only: [:index]
    resource :bank_account, only: [:edit, :update]
    resources :order_payments, except: %i[destroy]
    resources :balance_transferences, except: %i[destroy]

    # Shopping
    resources :products, only: [:index, :show]
    resource :cart, only: :show
    resource :checkout, only: :update
    resources :order_items, only: [:create, :update, :destroy]
    resources :payment_transactions, only: [:show]
    resource :payment_block_checkout, only: [:new]
    resource :payment_block_notification, only: [:create]
    resources :orders, only: [:index, :show] do
      post :generate_boleto
    end
    resources :cellphone_reloads, only: [:new, :create]
    resources :product_checkouts, only: %i[new create]

    # Financial
    resources :withdrawals, only: [:index, :new, :create, :edit, :update]
    resources :financial_transactions, only: [:index]
    resources :pv_histories, only: [:index]
    resources :pv_activity_histories, only: [:index]
    resources :accumulated_pva, only: [:index]
    resources :bonus_financial_transactions, only: [:index]
    resources :vouchers, only: [:index]
    resources :pay_with_voucher, only: [:show] do
      post :new
      post :create
    end

    # Network
    resources :binary_strategies, only: [:index, :create]
    resources :binary_tree, only: [:index, :show]
    resources :unilevel, only: [:index]
    resources :lineage_scores, only: [:index]
    resources :career_trail_users, only: [:index]
    resources :point_qualifications, only: [:index]

    # Sim Cards
    resources :users, only: [] do
      resources :sim_cards, only: [:index, :create]
      resources :sim_card_reports, only: [:index]
      resources :sim_card_transfers, only: :index
    end

    resources :banners, only: :index
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: :non do
        collection do
          post :sign_in
          post :sign_up
          post :find_by_cpf
          post :find_by_cnpj
          post :remember_password
        end
      end
    end
  end

  namespace :users do
    resources :digital_wallets, except: %i[show destroy]
    resources :emails, except: %i[show destroy]
  end

  devise_for(:users,
             controllers: {
              sessions: 'users/sessions',
              registrations: 'users/registrations',
              passwords: 'users/passwords',
              unlocks: 'users/unlocks',
              confirmations: 'users/confirmations',
              masquerades: 'masquerades' })

  devise_scope :user do
    authenticated :user do
      root 'backoffice/dashboard#index'
    end

    unauthenticated do
      root 'users/sessions#new'
    end
  end
end
