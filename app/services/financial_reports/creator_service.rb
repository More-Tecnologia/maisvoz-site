module FinancialReports
  class CreatorService < ApplicationService
    def call
      return if FinancialReport.exists?(begin_datetime: @begin_datetime,
                                        end_datetime: @end_datetime)
      financial_report
    end

    private

    def initialize(args)
      @begin_datetime = args[:begin_datetime]
      @end_datetime = args[:end_datetime]
    end

    def financial_report
      FinancialReport.create!(order_payment_amount_cents: order_payment_amount * 100,
                              withdrawal_amount_cents: withdrawal_amount * 100,
                              begin_datetime: @begin_datetime,
                              end_datetime: @end_datetime)
    end

    def order_payment_amount
      @order_payments ||= FinancialTransaction.to_customer_admin
                                              .order_payments
                                              .created_at(@begin_datetime, @end_datetime)
                                              .sum(:cent_amount) / 1e8
    end

    def withdrawal_amount
      @withdrawal_amount ||= FinancialTransaction.to_customer_admin
                                                 .withdrawals
                                                 .created_at(@begin_datetime, @end_datetime)
                                                 .sum(:cent_amount) / 1e8
    end
  end
end
