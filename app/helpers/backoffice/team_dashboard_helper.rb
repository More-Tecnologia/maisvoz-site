module Backoffice
  module TeamDashboardHelper

    def expensive_product_active(user)
      contracts = user.bonus_contracts.active.sort do |contract, other|
        contract.order_items.last.task_per_day.to_i <=> other.order_items.last.task_per_day.to_i
      end
      contracts.first
    end
  end
end
