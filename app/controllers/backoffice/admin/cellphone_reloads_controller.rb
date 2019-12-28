module Backoffice
  module Admin

    class CellphoneReloadsController < AdminController

      def index
        @q = OrderItem.ransack(params[:q])
        @cellphone_reloads = @q.result
                               .includes(:order, :product)
                               .cellphone_reloads
                               .where(order: Order.completed.paid)
                               .page(params[:q])
      end

    end

  end
end
