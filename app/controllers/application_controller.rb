class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :null_session

  before_action :masquerade_user!
  before_action :set_locale

  def after_sign_in_path_for(resource)
    show_ticket_alert if current_user &&
                         !current_user.admin? &&
                         Ticket.where(user: current_user)
                               .active
                               .answered.any?
    if params[:raffle].present?
      redirect_to raffle_tickets_path(params[:raffle][:id])
    else
      dashboard_direction(current_user)
    end
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

  def show_daily_task_alert
    quantity = BannerClick::QUANTITY_MINIMUM_VIEW_PER_DAY
    flash[:alert] = t('errors.messages.daily_task', quantity: quantity) if !DateTime.current.on_weekend?
  end

  def show_ticket_alert
    flash[:alert] = t('errors.messages.your_tickets_were_answered')
  end

  def redirect_to_banners
    show_daily_task_alert
    redirect_to backoffice_banners_path
  end

  def dashboard_direction(user)
    if user.admin?
      backoffice_admin_dashboard_index_path
    else
      if SystemConfiguration.whitelabel?
        raffles_backoffice_stores_path
      else
        raffles_backoffice_stores_path
      end
    end
  end
end
