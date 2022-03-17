module Bonification
  class CourseSaleService < ApplicationService
    def call
      transaction = create_sale
      if @seller.inactive?
        chargeback_reason = transaction.financial_reason.chargeback_by_inactivity
        transaction.chargeback_by_inactivity!(chargeback_reason)
      end
    end

    private

    def initialize(params)
      @seller = params[:seller]
      @user = params[:user]
      @amount = params[:amount]
      @product = params[:product]
    end

    def create_sale
      cent_amount = @amount - (@product.network_commission_percentage * @amount)

      @seller.financial_transactions
             .create!(spreader: @user,
                     financial_reason: FinancialReason.course_sale,
                     moneyflow: :credit,
                     cent_amount: cent_amount) if cent_amount.positive?
    end
  end
end
