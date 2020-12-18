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

  # def current_order
  #   if session[:order_id].present? && current_user.orders.exists?(session[:order_id])
  #     @current_order ||= Order.find(session[:order_id])
  #   else
  #     @current_order ||= Order.new(user: current_user)
  #   end
  # end

  def link_to_user(user, *opts)
    return unless user
    link_to(user.username, backoffice_support_user_path(user), *opts)
  end

  def sponsor_from_username(params)
    @sponsor_from_username ||= User.empreendedor.find_by(username: params[:sponsor]).try :username
  end

  def link_to_contract
    link_to t('defaults.contract_link_html'), ENV.fetch('CONTRACT_URL'), target: "_blank"
  end

  def batch_action_checkbox_parent
    check_box_tag :select, '', false, class: 'parent'
  end

  def batch_action_checkbox_child(withdrawal)
    check_box_tag :select, withdrawal.id, false, class: 'child'
  end

  def boolean_select_options
    [[t('true'), true],
     [t('false'), false]]
  end

  def disable_spinner
    content_tag :i, '', class: 'fa fa-spinner fa-spin'
  end

  def ensure_cloudinary_image(path, options)
    return cl_image_tag(path, options) if path

    image_tag('fallback/default_product.png', options)
  end

  def error_messages(object, attribute)
    errors = object.errors[attribute]
    return unless errors&.any?

    errors = errors.join(', ')
    content_tag :span, errors, class: 'field-error-messages'
  end

  def country_name(country_code)
    country = ISO3166::Country[country_code]
    return if country.blank?

    country.translations[I18n.locale.to_s] || country.name
  end
end
