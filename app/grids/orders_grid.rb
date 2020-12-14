class OrdersGrid < BaseGrid

  scope do
    Order.includes(:user, :payer, :payment_transaction)
         .order(id: :desc)
  end

  filter(:id, header: I18n.t(:hashid)) do |value, scope|
    order = Order.find(value)
    scope.where(id: order.try(:id))
  end
  filter(:status, :enum, header: I18n.t('attributes.status'), select: Order.statuses.map {|k,v| [I18n.t(k), v]})
  filter(:username, header: I18n.t('attributes.username')) do |value, scope|
    scope.joins(:user).where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:billed, :xboolean, header: I18n.t('attributes.billed'))
  filter(:created_at, :date, :range => true, header: I18n.t('attributes.created_at'))
  filter(:payment_type, :enum, select: Order.payment_types, header: I18n.t('attributes.payment_type'))

  column(:hashid, header: I18n.t(:hashid))
  column(:created_at, header: I18n.t('attributes.created_at'), html: true) do |order|
    payment_transaction_link(order)
  end
  column(:username, html: true, header: I18n.t('attributes.user')) do |record|
    link_to_user(record.user)
  end
  column(:main_document, html: false) do |record|
    record.user.decorate.main_document
  end
  column(:email, html: false) do |record|
    record.user.email
  end
  column(:total, header: I18n.t('attributes.value'), html: true) do |record|
    number_to_currency(record.total)
  end
  column(:status, html: true) do |record|
    css_class = { completed: 'badge badge-success',
                  expired: 'badge badge-warning' }[record.status.to_s.to_sym]
    css_class = css_class || 'badge badge-danger'

    content_tag(:span, t(record.status), class: css_class)
  end
  column(:paid_at, order: 'paid_at is not null desc, paid_at',
                   order_desc: 'paid_at is not null desc, paid_at desc',
                   html: true,
                   header: I18n.t('attributes.paid_at')) do |order|
    order.paid_at.try(:strftime, '%d/%m/%Y %H:%M')
  end
  column(:payment_type, header: I18n.t('payment_type'), html: true) do |order|
    payment_type_badge(order)
  end
  column(:payer, header: I18n.t('attributes.payer')) do |record|
    record.paid_by || record.try(:payer).try(:username)
  end
  date_column(:expire_at, html: false)
  column(:actions, html: true, header: I18n.t(:actions)) do |order|
    actions = ''
    actions.concat(billet_link(order)) if !order.billed?
    actions.concat(approver_order_link(order)) if !order.completed?
    actions.concat(approval_withdrawal_bonification_link(order)) if !order.completed?
    actions.html_safe
  end
end
