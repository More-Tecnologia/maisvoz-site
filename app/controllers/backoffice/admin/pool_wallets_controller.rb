module Backoffice
  module Admin
    class PoolWalletsController < AdminController

      def index
        @pool_wallet = PoolWallet.all
      end

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

      def destroy
        @pool_wallet.toggle!
        redirect_to backoffice_admin_pool_wallets_path
      end

      private

      def valid_params
      end

      def ensure_pool_wallet
      end
    end
  end
end
