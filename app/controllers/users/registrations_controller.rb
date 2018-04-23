class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  layout :define_layout, only: [:edit, :update]

  # GET /resource/sign_up
  def new
    build_resource({})
    sponsor_username = User.empreendedor.find_by(username: params[:sponsor]).try(:username)

    form = NewRegistrationForm.new(sponsor_username: sponsor_username)
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
      render(:new, locals: { form: form, sponsor: params[:sponsor] })
    end
  end

  # GET /resource/edit
  def edit
    render_edit
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    update_resource(resource, edit_form.attributes)

    yield resource if block_given?
    if edit_form.valid? && resource_updated = resource.save
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
      render_edit
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

  def render_edit
    render :edit, locals: { form: edit_form }
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:sponsor_username, :username, :name, :birthdate, :marital_status, :phone]
    )
  end

  def form
    @form ||= NewRegistrationForm.new(params.fetch(:user, {}).permit!)
  end

  def edit_form
    @form ||= EditRegistrationForm.new(params.fetch(:user, resource.attributes).permit!)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:name, :birthdate, :marital_status, :phone, :email, :document_cpf, :address, :address_2, :country, :state, :city, :avatar]
    )
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    backoffice_dashboard_index_path
  end

  def after_update_path_for(resource)
    root_path
  end

  private def define_layout
    current_user.consumidor? ? 'consumer' : 'admin'
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
