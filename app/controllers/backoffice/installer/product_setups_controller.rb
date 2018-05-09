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
        render_new
      end

      def create
        if form.valid? && ProductSetupSave.new(form).call
          flash.now[:success] = 'Instalação salva com sucesso'
          render_index
        else
          render_new
        end
      end

      private

      def render_index
        render :index, locals: { product_setups: product_setups }
      end

      def render_new
        render :new, locals: { form: form }
      end

      def form
        @form ||= ProductSetupForm.new(form_params)
      end

      def form_params
        params[:product_setup_form] ||= {}
        params[:product_setup_form][:installer] = current_user
        params[:product_setup_form]
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
