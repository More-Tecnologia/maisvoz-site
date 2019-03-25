module Backoffice
  module Admin
    class OrdersController < BackofficeController

      def index
        authorize :admin_order, :index?

        @grid = OrdersGrid.new(grid_params)

        respond_to do |format|
          format.html { render_index }
          format.csv { render_csv }
        end
      end

      def show
        authorize :admin_order, :show?

        @order = Order.find(params[:id])
      end

      def approve
        return unless current_user.admin?

        command = Financial::PaymentCompensation.call(order)

        if command.success?
          order.update!(
            payment_type: Order.payment_types[:admin],
            paid_by: current_user.username
          )
          flash[:success] = I18n.t('defaults.approved_success')
        else
          flash[:error] = command.errors[:order].join(',')
        end
        redirect_to backoffice_admin_orders_path
      end

      def mark_as_billed
        if order.update_column :billed, true
          flash[:success] = 'Pedido marcado como faturado'
        end
        redirect_to backoffice_admin_orders_path
      end

      private

      def render_index
        @grid.scope {|scope| scope.page(params[:page]) }
      end

      def render_csv
        send_data @grid.to_csv,
          type: "text/csv",
          disposition: 'inline',
          filename: "orders-#{Time.now.to_s}.csv"
      end

      def order
        @order ||= Order.find(params[:order_id])
      end

      def grid_params
        params.fetch(:orders_grid, {}).permit!
      end

    end
  end
end
