module Backoffice
  module Admin
    class PoolWalletsController < AdminController
      before_action :ensure_pool_wallet, only: %i[edit update]

      def new
        @pool_wallet = PoolWallet.new
      end

      def create
        @pool_wallet = PoolWallet.new(valid_params)
        if @pool_wallet.save?
          flash[:success] = t('.success')
          redirect_to backoffice_admin_pool_wallets_path
        else
          flash[:error] = @pool_wallet.errors.full_messages.join(', ')
          render :new
        end
      end

      def edit; end

      def update
        if @pool_wallet.update(valid_params)
          flash[:success] = t('.success')
          redirect_to backoffice_admin_pool_wallets_path
        else
          flash[:error] = @pool_wallet.errors.full_messages.join(', ')
          render :edit
        end
      end

      private

      def valid_params
        params.require(:pool_wallet)
              .permit(:title, :wallet)
      end

      def ensure_pool_wallet
        @pool_wallet = PoolWallet.find(params[:id])
      end
    end
  end
end
