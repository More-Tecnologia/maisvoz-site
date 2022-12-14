module Backoffice
  module OrdersHelper
    PRODUCT_PATH_LIST = {
      course: [:backoffice_course_path, :course],
      deposit: :backoffice_products_path,
      publicity: :backoffice_admin_banner_stores_path,
      raffle: [:backoffice_raffles_ticket_path, :raffle]
    }

    def valid_deposit_options
      deposit_options.select { |d| d.second >= minimum_deposit_value }
    end

    def deposit_options
      OrderItem::QUANTITIES.map do |q|
        label_quantity = q > 10 ? q - 5 : q

        ["Publi - #{label_quantity}", q]
      end
    end

    def minimum_deposit_value
      @maximum_deposit ||= current_user.orders
                                       .paid
                                       .pluck(:total_cents)
                                       .max.to_f / 100.0
    end

    def payment_status_tag(order)
      css_class = 'badge-danger'
      if order.completed?
        css_class = 'badge-success'
      elsif order.expired?
        css_class = 'badge-warning'
      end
      content_tag(:span, t(order.status), class: ['badge', css_class])
    end

    def billet_link(order)
      link_to backoffice_admin_order_mark_as_billed_path(order),
              class: 'm-r-10',
              method: :post,
              data: { toggle: :tooltip,
                      title: t(:bill) } do
        content_tag :i, '', class: 'fas fa-stamp'
      end
    end

    def product_path_list(product)
      path = PRODUCT_PATH_LIST[product.kind.to_sym]
      return unless path
      
      path.is_a?(Array) ? send(path.first, product.send(path.last)) : send(path)
    end

    def link_to_product_by_kind(product)
      path = product_path_list(product)
      path ? (link_to product.name, path) : product.name
    end

    def payment_transaction_link(order)
      return order.created_at.strftime('%d/%m/%Y %H:%M') if order.payment_transaction.blank?

      link_to order.created_at.strftime('%d/%m/%Y %H:%M'),
              backoffice_payment_transaction_path(order.payment_transaction),
              class: 'm-r-10',
              data: { toggle: :tooltip,
                      title: t(:checkout) }
    end

    def approver_order_link(order)
      link_to backoffice_admin_order_approve_path(order),
              class: 'm-r-10',
              method: :post,
              data: { toggle: :tooltip,
                      title: t(:approve),
                      confirm: t(:want_approve_bill) } do
        content_tag :i, '', class: 'fas fa-thumbs-up text-success'
      end
    end

    def approval_withdrawal_bonification_link(order)
      link_to backoffice_admin_order_approver_without_bonification_path(order),
              method: :patch,
              data: { confirm: t('helpers.confirm.approve_order_without_bonification'),
                      toggle: :tooltip,
                      title: t(:approve_without_bonification) } do
        content_tag :i, '', class: 'fas fa-thumbs-up text-warning'
      end
    end

    def payment_type_badge_class(order)
     { balance: 'badge badge-info',
       admin: 'badge badge-success',
       voucher: 'badge badge-muted',
       btc: 'badge badge-primary',
       admin_nb: 'badge badge-warning' }[order.payment_type.to_s.to_sym]
    end

    def payment_type_badge(order)
      content_tag :span, order.payment_type, class: payment_type_badge_class(order)
    end

    def order_status_style_class(order)
      { pending_payment: 'status-pending',
        processing: 'status-waiting',
        completed: 'status-success',
        expired: 'status-canceled',
        waiting: 'status-waiting',
        pending: 'status-pending',
        canceled: 'status-canceled',
        approved: 'status-success'  }[order.status.to_sym]
    end
  end
end
