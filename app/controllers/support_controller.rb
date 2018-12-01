class SupportController < BackofficeController

  before_action :ensure_admin_or_support
  before_action :ensure_time_limit

  private

  def ensure_admin_or_support
    return if signed_in? && (current_user.admin? || current_user.suporte?)
    flash[:error] = 'Você precisa ser admin ou suporte'
    redirect_to '/'
  end

  def ensure_time_limit
    hour = Time.zone.now.hour
    return if hour > 8 && hour < 19

    flash[:error] = 'Restrição de horário, login liberado entre as 8h e 19h'
    redirect_to '/'
  end

end
