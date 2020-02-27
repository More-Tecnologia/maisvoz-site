class ApplicationController < ActionController::Base

  protect_from_forgery prepend: true, with: :exception
  before_action :masquerade_user!
  before_action :set_locale

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def self.default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def append_info_to_payload(payload)
    super

    payload[:user_id] = current_user.id if current_user.present?
  end

  def filled?(attribute)
    return attribute.present? if attribute.is_a?(String)
    attribute.join.present? if attribute.is_a?(Array)
  end

  def cleasing_decimal_number(number)
    number.to_s.gsub('.','').gsub(',','.').to_f
  end

end
