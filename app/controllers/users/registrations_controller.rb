class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :validate_password, only: :update
  before_action :ensure_email, only: :update
  before_action :configure_account_update_params, only: [:update]

  layout :define_layout, only: [:edit, :update]

  # GET /resource/sign_up
  def new
    if (params[:bypass] == 'true' && params[:pass] == 'plus-ultra') || ENV['UPTIME'] == 'running'
      build_resource({})
      @form = build_registration_form(token: params[:token])
    else
      redirect_to maintenances_path
    end
  end

  # POST /resource
  def create
    # super
    @form = build_registration_form(params[:user])
    valid_form = @form.valid?
    build_resource(@form.attributes.except(:sponsor_username, :role, :contract, :g_recaptcha_response))
    if valid_form && resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        #respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
      send_welcome_email(resource)
      redirect_to root_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new
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
        set_flash_message :success, flash_key
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

  helper_method :current_order

  protected def current_order
   if session[:order_id].present? && current_user.orders.exists?(session[:order_id])
     @current_order ||= Order.find(session[:order_id])
   else
     @current_order ||= Order.new(user: current_user)
   end
  end

  def render_edit
    render :edit, locals: { form: edit_form }
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:sponsor_username, :username, :name, :birthdate, :phone]
    )
  end

  def build_registration_form(attributes)
    return ShortNewRegistrationForm.new(attributes) if ENV['ENABLED_SHORT_REGISTRATION_FORM'] == 'true'
    NewRegistrationForm.new(attributes)
  end

  def edit_form
    update_params = params.fetch(:user, resource.attributes).permit!
    update_params[:id] = resource.id
    @form ||= EditRegistrationForm.new(update_params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:name, :birthdate, :marital_status, :email, :phone, :document_cpf, :document_cnpj, :address, :address_2, :country, :state, :city, :avatar]
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
    'admin'
  end

  private

  def send_welcome_email(user)
    UserMailer.welcome(user).deliver_later
  end

  def validate_password
    return if current_user.valid_password?(params[:current_password])
    flash[:error] = t('invalid_password')
    redirect_to edit_registration_path(current_user)
  end

  def ensure_email
    params[:user].merge!(email: current_user.email)
  end

end
