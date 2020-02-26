class OrdersGrid < BaseGrid

  scope do
    Order.includes(:user).order(id: :desc)
  end

  filter(:id, :integer)
  filter(:status, :enum, header: I18n.t('attributes.status'), select: Order.statuses.map {|k,v| [I18n.t(k), v]})
  filter(:username, header: I18n.t('attributes.username')) do |value, scope|
    scope.joins(:user).where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:billed, :xboolean, header: I18n.t('attributes.billed'))
  filter(:created_at, :date, :range => true, header: I18n.t('attributes.created_at'))
  filter(:payment_type, :enum, select: Order.payment_types, header: I18n.t('attributes.payment_type'))

  column(:id)
  column(:hashid)
  column(:username, html: true) do |record|
    link_to_user(record.user)
  end
  column(:name) do |record|
    record.user.decorate.name_or_company_name
  end
  column(:main_document, html: false) do |record|
    record.user.decorate.main_document
  end
  column(:email, html: false) do |record|
    record.user.email
  end
  column(:total) do |record|
    ActiveSupport::NumberHelper.number_to_currency record.total
  end
  column(:payment_type)
  column(:paid_by)
  date_column(:created_at)
  date_column(:paid_at, order: 'paid_at is not null desc, paid_at', order_desc: 'paid_at is not null desc, paid_at desc')
  date_column(:expire_at, html: false)
  column(:faturado, html: true) do |order|
    if !order.billed?
      link_to(backoffice_admin_order_mark_as_billed_path(order),
        method: :post,
        class: 'm-r-10'
      ) do
        '<i class="fa fa-check"></i>'.html_safe
      end
    else
      '<i class="fa fa-check-circle text-success"></i>'.html_safe
    end
  end
  column(:status) do |record|
    format(record.status) do |value|
      css_class = 'badge-danger'
      if record.completed?
        css_class = 'badge-success'
      elsif record.expired?
        css_class = 'badge-warning'
      end
      content_tag(:span, t(value), class: ['badge', css_class])
    end
  end
  column(:details, html: true) do |order|
      link_to('Detalhe', backoffice_admin_order_path(order))
      link_to('Detalhe', backoffice_admin_order_path(order))
  end
  column(:approve, html: true) do |order|
    if !order.completed?
      link_to(backoffice_admin_order_approve_path(order),
        method: :post,
        data: { confirm: 'Deseja aprovar esta fatura?' },
        class: 'm-r-10'
      ) do
        '<i class="fa fa-check"></i>'.html_safe
      end
    end
  end
  column(:approve_without_bonification, html: true, header: I18n.t('defaults.approve_order_without_bonification')) do |order|
    if !order.completed?
      link_to(backoffice_admin_order_approver_without_bonification_path(order),
              method: :patch,
              data: { confirm: I18n.t('helpers.confirm.approve_order_without_bonification') },
              class: 'm-r-10') do
        '<i class="fa fa-check"></i>'.html_safe
      end
    end
  end
end
