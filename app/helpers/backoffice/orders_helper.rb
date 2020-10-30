module Backoffice
  module OrdersHelper
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
  end
end
