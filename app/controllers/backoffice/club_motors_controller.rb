module Backoffice
  class ClubMotorsController < BackofficeController

    before_action :verify_user_has_package

    def new
      render_new
    end

    def create
      if params[:commit].present? && form.valid?
        club_motors_signup
        flash[:success] = I18n.t('defaults.order_placed')
        redirect_to backoffice_orders_path
      else
        render_new
      end
    end

    private

    def render_new
      render(:new, locals: { form: form })
    end

    def form
      @form ||= ClubMotorsNewSubscriptionForm.new(form_params)
    end

    def form_params
      params[:club_motors_new_subscription_form]        ||= {}
      params[:club_motors_new_subscription_form][:user] ||= current_user
      params[:club_motors_new_subscription_form]
    end

    def club_motors_signup
      Subscriptions::ClubMotorsSignup.new(form: form).call
    end

    def verify_user_has_package
      return if current_user.product.blank?

      flash[:success] = 'Você já possui um pacote cadastrado'

      redirect_to backoffice_dashboard_index_path
    end

  end
end
