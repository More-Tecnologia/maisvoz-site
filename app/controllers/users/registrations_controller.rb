class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  layout 'admin', only: [:edit, :update]

  # GET /resource/sign_up
  def new
    build_resource({})
    form = NewRegistrationForm.new
    render locals: { form: form }
  end

  # POST /resource
  def create
    # super
    build_resource(form.attributes.except(:sponsor_username, :accept_terms))

    resource.sponsor = form.sponsor

    if form.valid? && resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render(:new, locals: { form: form })
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    raise 'destroying not allowed'
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:sponsor_username, :username, :name, :phone, :skype])
  end

  def form
    @form ||= NewRegistrationForm.new(params.fetch(:user).permit!)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :birthdate, :phone, :skype, :email, :document_value, :address, :address_2, :country, :state, :city])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    backoffice_dashboard_index_path
  end

  def after_update_path_for(resource)
    backoffice_dashboard_index_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
