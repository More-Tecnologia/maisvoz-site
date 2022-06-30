# frozen_string_literal: true

module Payment
  class PromotionalBalanceService < ApplicationService
    def initialize(params)
      @order = params[:order]
      @user = params[:third_party_user].presence || @order.user
      @amount = @order.total_cents / 100
    end

    private

    def call
      raise StandardError.new(I18n.t(:doesnt_have_enough_promotional_balance)) if @user.promotional_balance < @amount
      max_ticket_value_verification
      ActiveRecord::Base.transaction do
        debit_promotional_amount_from_user_promotional_balance
        create_order_payment
        @order.payment_type = :promotional_balance
        @order.status = :pending_payment
        @order.save

        Financial::PaymentCompensation.call(@order, false)
      end
    end

    def create_order_payment
      User.find_morenwm_customer_admin
          .financial_transactions
          .create!(spreader: @user,
                   financial_reason: FinancialReason.order_payment_with_promotional_balance,
                   cent_amount: @amount,
                   moneyflow: :not_applicable)
    end

    def debit_promotional_amount_from_user_promotional_balance
      @user.decrement!(:promotional_balance, @amount)
    end

    def helpers
      ApplicationController.helpers
    end

    def max_ticket_value_verification
      raffle_by_being_purchased_value.each do |raffle, value|
        if previous_quantity_purchased_by_promotional_credit_reached?(raffle)
          raise StandardError.new(I18n.t(:current_maximum_amount_of_tickets_reached_by_promotional_payment_html, raffle: raffle.product.name + ' ID: ' + raffle.id.to_s)) 
        elsif quantity_purchased_by_promotional_credit_reached?(raffle, value)
          raise StandardError.new(I18n.t(:amount_of_tickets_by_promotional_payment_left_html, raffle: (raffle.product.name + ' ID: ' + raffle.id.to_s), ticket_values: helpers.number_to_currency((@user.brute_promotional_balance / 10) - product_quantity_purchased_with_promotional_credit(raffle)))) 
        end
      end
    end

    def product_quantity_purchased_with_promotional_credit(raffle)
      promotional_raffle_tickets = raffle.raffle_tickets
                                         .joins(:order_item)
                                         .where(user: @user, order_items: { order: @user.orders.promotional_balance })
      promotional_raffle_tickets.count * (raffle.product.price_cents / 100).to_f
    end

    def previous_quantity_purchased_by_promotional_credit_reached?(raffle)
      product_quantity_purchased_with_promotional_credit(raffle) >= (@user.brute_promotional_balance / 10) 
    end

    def quantity_purchased_by_promotional_credit_reached?(raffle, value)
      product_quantity_purchased_with_promotional_credit(raffle) + value > (@user.brute_promotional_balance / 10) 
    end

    def raffle_by_being_purchased_value
      @order.order_items
            .map(&:raffle_ticket)
            .group_by(&:raffle)
            .map { |raffle, raffle_tickets| [raffle, (raffle_tickets.count * (raffle.product.price_cents / 100))] }
            .to_h
    end
  end
end