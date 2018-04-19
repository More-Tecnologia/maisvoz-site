module ApplicationHelper

  def flash_class(level)
    case level
    when 'notice' then 'info'
    when 'success' then 'success'
    when 'error' then 'error'
    when 'alert' then 'warning'
    end
  end

  def decorate_amount(amount)
    style_class = amount < 0 ? 'text-danger' : amount > 0 ? 'text-success' : 'text-primary'
    content_tag :span, class: style_class do
      number_to_currency amount
    end
  end

  def current_order
    if session[:order_id].present? && current_user.orders.exists?(session[:order_id])
      @current_order ||= Order.find(session[:order_id])
    else
      @current_order ||= Order.new(user: current_user)
    end
  end

  def link_to_user(user)
    return unless user
    link_to(user.username, backoffice_admin_user_path(user))
  end

end
