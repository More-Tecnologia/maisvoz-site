module ApplicationHelper

  def flash_class(level)
    case level
    when 'notice' then 'info'
    when 'success' then 'success'
    when 'error' then 'error'
    when 'alert' then 'warning'
    end
  end

  def current_order
   if !session[:order_id].nil? && Order.exists?(session[:order_id])
     @current_order ||= Order.find(session[:order_id])
   else
     @current_order ||= Order.new(user: current_user)
   end
  end

end
