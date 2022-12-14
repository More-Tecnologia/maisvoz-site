module ApplicationHelper
  def admoney?
    ActiveModel::Type::Boolean.new.cast(ENV['ADMONEY'])
  end

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

  def current_order_shipping_countries
    @current_order_shipping_countries =
      current_order.products.map(&:shippings).flatten.map(&:country).uniq
  end

  def account_type_label(user)
    content_tag :span, user.type.try(:name), class: 'label label-success'
  end

  def copier_button(copiable_text, data_target)
    link_to '#', class: 'btn btn-purple btn-xs copier',
                 data: { copiable: copiable_text, target: data_target } do
      content_tag :i, '', class: 'fas fa-copy text-white'
    end
  end

  def seconds_to_hms(sec)
    "%02d:%02d:%02d" % [sec / 3600, sec / 60 % 60, sec % 60]
  end

  def current_currencies_rates
    @current_currencies_rates ||= Webhooks::Coinbase::DollarExchangeRates.call
  end

  def currency_price origin_currency, cents, target_currency = ENV['CURRENT_CURRENCY']
    currency_cents(origin_currency, cents, target_currency) / 100.0
  end

  def batch_action_checkbox_parent
    check_box_tag :select, '', false, class: 'parent'
  end

  def batch_action_checkbox_child(withdrawal)
    check_box_tag :select, withdrawal.id, false, class: 'child'
  end

  def pagstar_active?
    ActiveModel::Type::Boolean.new.cast(ENV['PAGSTAR_ACTIVE'])
  end

  def promotional_balance?
    ActiveModel::Type::Boolean.new.cast(ENV['PROMOTIONAL_BALANCE'])
  end

  private

  def currency_cents origin_currency, cents, target_currency = ENV['CURRENT_CURRENCY']
    return cents if origin_currency == target_currency

    cents.to_d * current_currencies_rates.dig(target_currency) /
    current_currencies_rates.dig(origin_currency)
  end
end
