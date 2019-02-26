class OrdersGrid < BaseGrid

  scope do
    Order.where.not(status: :cart).includes(:user).includes(:payable).order(id: :desc)
  end

  filter(:id, :integer)
  filter(:status, :enum, select: Order.statuses.map {|k,v| [I18n.t(k), v]})
  filter(:type, :enum, select: Order.types.map {|k,v| [I18n.t(k), v]})
  filter(:username) do |value, scope|
    scope.joins(:user).where('users.username ILIKE ?', "%#{value}%")
  end

  column(:id)
  column(:hashid)
  column(:username, html: true) do |record|
    link_to_user(record.user)
  end
  column(:name, html: false) do |record|
    record.user.decorate.name_or_company_name
  end
  column(:main_document, html: false) do |record|
    record.user.decorate.main_document
  end
  column(:email) do |record|
    record.user.email
  end
  column(:total) do |record|
    ActiveSupport::NumberHelper.number_to_currency record.total_cents / 100
  end
  column(:type) do |record|
    record.decorated_type
  end
  column(:payment_type)
  column(:paid_by)
  date_column(:created_at)
  date_column(:paid_at, order: 'paid_at is not null desc, paid_at', order_desc: 'paid_at is not null desc, paid_at desc')
  column(:dr_recorded) do |record|
    format(record.dr_recorded) do |value|
      if record.dr_recorded?
        content_tag(:i, nil, class: 'fa fa-check-circle text-success')
      else
        content_tag(:i, nil, class: 'fa fa-times-circle text-danger')
      end
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
end
