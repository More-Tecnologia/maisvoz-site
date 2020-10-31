module Backoffice
  class OrderPaymentsController < BackofficeController
    include Backoffice::OrderPaymentsHelper

    before_action :validate_order, only: %i[new create]
    before_action :validate_user_password, only: :create
    before_action :validate_payer_user_balance, only: :create

    def index
      @q = Order.ransack(params[:q])
      @orders = @q.result
                  .includes(:user, :payment_transaction)
                  .where(payer: current_user)
                  .order(paid_at: :desc)
                  .page(params[:page])
    end

    def new; end

    def create
      debit_order_value_from_current_user(current_user, @order)
      PaymentCompensationWorker.perform_async(@order.id)

      flash[:notice] = t('.success')
      redirect_to backoffice_financial_transactions_path
    end
  end
end
