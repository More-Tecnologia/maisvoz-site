module Backoffice
  module ClubMotors
    class VehiclesController < BackofficeController

      def index
        @vehicles = current_user.club_motors_subscriptions
        @package_name = package_name
      end

      def edit
        render_edit
      end

      def update
        if form.valid? && club_motors_subscription.update!(form.edit_attributes)
          flash[:success] = 'Veículo atualizado com sucesso!'
          redirect_to backoffice_club_motors_vehicles_path
        else
          render_edit
        end
      end

      private

      def render_edit
        render(:edit, locals: { form: form, club_motors_subscription: club_motors_subscription })
      end

      def form
        @form ||= ClubMotorsSubscriptionForm.new(form_params)
      end

      def form_params
        if params[:id].present?
          params[:club_motors_subscription_form] ||= club_motors_subscription.attributes
        end
        params[:club_motors_subscription_form]
      end

      def club_motors_subscription
        current_user.club_motors_subscriptions.find_by_hashid(params[:id])
      end

      def package_name
        return if current_user.product.blank?

        @package_name ||= current_user.product.name
      end

    end
  end
end
