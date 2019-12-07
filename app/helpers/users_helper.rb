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

  def render_available_balance_link(user)
    available_balance = number_to_currency(user.available_balance_cents)
    link_to available_balance, backoffice_financial_transactions_path,
                               class: 'nav-link dropdown-toggle waves-effect text-success',
                               role: :button,
                               'aria-haspopup': false,
                               'aria-expanded': false
  end

  def render_blocked_balance_link(user)
    blocked_balance = number_to_currency(user.blocked_balance_cents)
    link_to blocked_balance, backoffice_financial_transactions_path,
                             class: 'nav-link dropdown-toggle waves-effect text-warning',
                             role: :button,
                             'aria-haspopup': false,
                             'aria-expanded': false
  end

end
