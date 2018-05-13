module Backoffice
  module Installer
    class ProductSetupsController < InstallerController

      def index
        render_index
      end

      def show
        render :show, locals: { product_setup: product_setup }
      end

      def new
        @product_setup = ProductSetup.new
      end

      def create
        @product_setup = ProductSetup.new(product_setup_params)

        @product_setup.installer = current_user
        @product_setup.status = 'pending'

        if @product_setup.valid?
          @product_setup.save!
          flash.now[:success] = 'Instalação salva com sucesso'
          render_index
        else
          render :new
        end
      end

      private

      def render_index
        render :index, locals: { product_setups: product_setups }
      end

      def product_setup_params
        params.require(:product_setup).permit!
      end

      def product_setup
        current_user.product_setups.find(ProductSetup.decode_id(params[:id]))
      end

      def product_setups
        current_user.product_setups.page(params[:page])
      end

    end
  end
end
