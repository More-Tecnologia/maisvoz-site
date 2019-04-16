module Backoffice
  module Installer
    class OrderOfServicesController < BackofficeController

      def index
        authorize :order_of_service, :index?

        @order_of_services = current_user.created_order_of_services.order(
          created_at: :desc
          ).page(params[:page])
        end

        def new
        authorize :order_of_service, :new?

        render_new
      end

      def create
        authorize :order_of_service, :create?

        if params[:search_user].present?
          render_new
        elsif form.valid? && params[:commit].present?
          Bonification::PropagateOrderOfServicePoints.new(form).call
          flash[:success] = 'OS registrada com sucesso'
          redirect_to backoffice_installer_order_of_services_path
        else
          render_new
        end
      end

      private

      def render_new
        render(:new, locals: {form: form})
      end

      def form
        @form ||= OrderOfServiceForm.new(form_params)
      end

      def form_params
        params[key] ||= {}
        params[key][:created_by] ||= current_user
        params[key]
      end

      def key
        :order_of_service_form
      end

    end
  end
end
