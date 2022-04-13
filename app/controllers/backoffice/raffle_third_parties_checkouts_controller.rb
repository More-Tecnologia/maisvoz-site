# frozen_string_literal: true

module Backoffice
  class RaffleThirdPartiesCheckoutsController < BackofficeController
    before_action :set_order, only: :create

    def create
      payment_with_balance
      cashback_for_third_party_payment

      flash[:success] = t(:successfully_paid)
      redirect_to backoffice_financial_dashboard_index_path
    rescue StandardError => error
      flash[:error] = error.message
      render 'backoffice/raffle_third_parties_carts/show'
    end

    private

    def cashback_for_third_party_payment
      ThirdPartiesCashbackWorker.perform_async(@order.id, current_user.id)
    end

    def payment_with_balance
      Payment::BalanceService.call(order: @order,
                                   third_party_user: current_user)
    end

    def set_order
      @order = Order.find_by_hashid(params[:order_id])
    end
  end
end
