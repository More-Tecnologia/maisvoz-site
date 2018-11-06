module Backoffice
  class ClubMotorsController < BackofficeController

    def new
      render_new
    end

    def create
      if params[:commit].present?
        form.valid?
      else
      end
      render_new
    end

    private

    def render_new
      render(:new, locals: { form: form })
    end

    def form
      @form ||= ClubMotorsSubscriptionForm.new(form_params)
    end

    def form_params
      params[:club_motors_subscription_form]        ||= {}
      params[:club_motors_subscription_form][:user] ||= current_user
      params[:club_motors_subscription_form]
    end

  end
end
