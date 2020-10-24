module Backoffice
  module OrdersHelper
    def valid_deposit_options
      deposit_options.select { |d| d.second > minimum_deposit_value }
    end

    def deposit_options
      maximum_deposit = current_user.orders
                                    .paid
                                    .pluck(:total_cents)
                                    .max.to_f

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
  end
end
