module Backoffice
  module Admin
    class OrderApproverWithoutBonificationsController < BackofficeController

      def update
        return unless current_user.admin?
        order = Order.find_by_hashid(params[:id])
        command = Financial::PaymentCompensation.call(order, false)

        if command.success?
          order.update!(payment_type: Order.payment_types[:admin_nb],
                        paid_by: current_user.username)
          flash[:success] = I18n.t('defaults.approved_success')
        else
          flash[:error] = command.errors[:order].join(',')
        end
        redirect_to backoffice_admin_orders_path
      end

    end
  end
end
