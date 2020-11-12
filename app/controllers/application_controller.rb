class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :reset_session
  before_action :masquerade_user!
  before_action :set_locale

  def after_sign_in_path_for(resource)
    return backoffice_banners_path if !current_user_seen_banners_today?

    request.env['omniauth.origin'] || stored_location_for(resource) || backoffice_dashboard_index_path
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

  def current_user_seen_banners_today?
    seen_at = current_user.banners_seen_at

    seen_at and seen_at == Date.today
  end
end
