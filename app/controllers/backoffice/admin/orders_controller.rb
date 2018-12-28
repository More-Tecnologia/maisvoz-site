module Backoffice
  module Admin
    class OrdersController < SupportController

      def index
        respond_to do |format|
          format.html { render_index }
          format.csv { render_csv }
        end
      end

      def show
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

      private

      def render_index
        render(:index, locals: { orders: orders, q: q })
      end

      def render_csv
        filename = "orders-#{Time.zone.now}.csv"
        send_data(ExportToCsv.call(collection: q.result, model: Order).result, filename: filename)
      end

      def order
        @order ||= Order.find(params[:order_id])
      end

      def orders
        @orders ||= q.result.page(params[:page])
      end

      def q
        @q ||= Order.where.not(status: :cart).ransack(q_params)
        @q.sorts = 'created_at desc' if @q.sorts.blank?
        @q
      end

      def q_params
        qparams = params[:q]
        qparams[:id_in] = params[:q][:id_in].split(' ') if params[:q].present? && params[:q].fetch(:id_in, nil).present?
        qparams
      end

    end
  end
end
