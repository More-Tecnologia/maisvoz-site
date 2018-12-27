module Backoffice
  class TrackersController < BackofficeController

    def new
      render_new
    end

    def create
      if params[:commit].present? && form.valid?
        Subscriptions::TrackerSignup.new(form: form).call
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
      @form ||= NewTrackerForm.new(form_params)
    end

    def form_params
      params[:new_tracker_form]        ||= {}
      params[:new_tracker_form][:user] ||= current_user
      params[:new_tracker_form]
    end

  end
end
