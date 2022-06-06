module UsersHelper
  def render_blocked_user_attribute_link(user)
    html_class = user.blocked ? 'fa fa-thumbs-up text-danger' : 'fa fa-thumbs-down'
    link_to( backoffice_support_blocked_user_path(user, blocked: !user.blocked),
             method: :put,
             remote: true,
             id: "user-#{user.id}-blocked" ) do
      content_tag :i, '', class: html_class
    end
  end

  def render_canceled_user_attribute_link(user)
    html_class = user.canceled ? 'fa fa-thumbs-up text-danger' : 'fa fa-thumbs-down'
    link_to( backoffice_support_canceled_user_path(user, canceled: !user.canceled),
             method: :put,
             remote: true,
             id: "user-#{user.id}-canceled" ) do
      content_tag :i, '', class: html_class
    end
  end

  def dashboard_direction(user)
    if user.admin?
      backoffice_admin_dashboard_index_path
    else
      if ActiveModel::Type::Boolean.new.cast(ENV['WHITELABEL'])
        backoffice_raffles_tickets_path
      else
        backoffice_dashboard_index_path
      end
    end
  end

  def hide_name(name)
    name.reverse.sub(/(?<=.).{4}?(?=.)/, '****').reverse
  end

  def available_balance(user)
    content_tag(:span, number_to_currency(user.available_balance),
                       class: 'm-r-10 font-16',
                       style: 'color: #FFF;',
                       data: {toogle: :tooltip, placement: :top},
                       title: 'available balance' )
  end

  def blocked_balance(user)
    content_tag(:span, number_to_currency(user.blocked_balance),
                       class: 'm-r-10 font-16',
                       style: 'color: #FFF;',
                       data: { toogle: :tooltip, placement: :top },
                       title: 'blocked balance')
  end

  def order_payment_balance(user)
    content_tag(:span, number_to_currency(current_user.transference_balance),
                       class: 'font-16',
                       style: 'color: #FFF;',
                       data: { toogle: :tooltip, placement: :top },
                       title: 'order payment balance')
  end

  def greater_order_value_from_the_source_user
    contract_values = current_user.bonus_contracts
                                  .active
                                  .yield_contracts
                                  .pluck(:cent_amount)

    contract_values.max.to_f / 100.0
  end
end
