module Users
  class DigitalWalletsController < BackofficeController
    before_action :ensure_digital_wallet, only: %i[edit update]
    before_action :same_wallet_verification, only: :create
    before_action :ensure_status, only: :create

    def index
      @digital_wallets = current_user.digital_wallets
                                     .order(updated_at: :desc)
    end

    def new
      @digital_wallet = DigitalWallet.new
    end

    def create
      if ensure_digital_wallet_existence
        flash[:success] = t('.success')
        redirect_to root_path
      else
        flash[:error] = @digital_wallet.errors.full_messages.join(', ')
        render :new
      end
    end

    def edit
      return if @digital_wallet.status.to_sym == :pending && params[:path] == 'email'

      flash[:success] = t('.unauthorized_action')
      redirect_to users_digital_wallets_path
    end

    def update
      if update_digital_wallet
        flash[:success] = t('.success')
        redirect_to users_digital_wallets_path
      else
        flash[:error] = @digital_wallet.errors.full_messages.join(', ')
        render :edit
      end
    end

    private

    def ensured_params
      params.require(:digital_wallet)
            .permit(:address)
            .merge(user: current_user)
    end

    def ensure_digital_wallet
      @digital_wallet = DigitalWallet.find_by_hashid(params[:id])
    end

    def ensure_digital_wallet_existence
      @digital_wallet =
        current_user.digital_wallets.where(address: params[:digital_wallet][:address]).first ||
          DigitalWallet.new(ensured_params)

      @digital_wallet.persisted? ? update_digital_wallet : create_digital_wallet
    end

    def ensure_status
      params[:digital_wallet].merge!(status: :pending)
    end

    def create_digital_wallet
      DigitalWallets::CreateService.call(@digital_wallet, params[:locale])
    end

    def update_digital_wallet
      DigitalWallets::UpdateService.call(@digital_wallet, params[:digital_wallet][:status], params[:locale])
    end

    def same_wallet_verification
      return unless params[:digital_wallet][:address] == current_user.wallet_address

      flash[:error] = t('.same_digital_wallet', digital_wallet: params[:digital_wallet][:address])
      redirect_to new_users_digital_wallet_path
    end
  end
end
