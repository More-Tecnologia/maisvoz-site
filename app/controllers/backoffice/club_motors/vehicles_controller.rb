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
          ActiveRecord::Base.transaction do
            Subscriptions::ActivateClubMotors.new(subscription: club_motors_subscription).call
            Subscriptions::CreateMonthlyInvoice.new(club_motors_subscription).call
          end

          flash[:success] = 'Veículo atualizado com sucesso!'
          redirect_to backoffice_club_motors_monthly_fees_path
        else
          render_edit
        end
      end

      def new
        render_new
      end

      def create
        if form.valid?
          Subscriptions::ClubMotorsAdd.new(form: form).call

          flash[:success] = 'Veículo adicionado com sucesso!'
          redirect_to backoffice_club_motors_monthly_fees_path
        else
          render_new
        end
      end

      private

      def render_edit
        render(:edit, locals: { form: form, club_motors_subscription: club_motors_subscription })
      end

      def render_new
        render(:new, locals: { form: form })
      end

      def form
        @form ||= ClubMotorsSubscriptionForm.new(form_params)
      end

      def form_params
        params[:club_motors_subscription_form] ||= {}
        if params[:id].present?
          params[:club_motors_subscription_form]                ||= club_motors_subscription.attributes
          params[:club_motors_subscription_form][:car_brand_id] ||= club_motors_subscription.car_model.car_brand.id
        end
        params[:club_motors_subscription_form][:user] ||= current_user
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
