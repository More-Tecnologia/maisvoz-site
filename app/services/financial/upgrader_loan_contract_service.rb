module Financial
  class UpgraderLoanContractService < ApplicationService
    def call
      return unless @loan_bonus_contract
      ActiveRecord::Base.transaction do
        resgister_loan_contract_payment_to_company_financial
        paid_bonus_to_contract_user_sponsors
        upgrade_loan_contract_to_rentability_contract if user_paid_loan_contract?
      end
    end

    private

    def initialize(args)
      @user = args[:user]
      @financial_transaction_bonus = args[:financial_transaction_bonus]
      @rentability_days_count = BonusContract::RENTABILITY_DAYS_COUNT
      @loan_bonus_contract = @user.current_loan_contract
    end

    def user_paid_loan_contract?
      user_yield_bonus = @user.financial_transactions
                              .to_empreendedor
                              .yield_bonus
                              .sum(:cent_amount) / 1e8.to_f
      @user.available_balance - user_yield_bonus >= @loan_bonus_contract.cent_amount
    end

    def resgister_loan_contract_payment_to_company_financial
      user = User.find_morenwm_customer_admin
      user.financial_transactions
          .create!(spreader: @loan_bonus_contract.user,
                   financial_reason: FinancialReason.loan_payment,
                   cent_amount: detect_loan_contract_payment_value,
                   moneyflow: :credit,
                   bonus_contract: @loan_bonus_contract)
    end

    def detect_loan_contract_payment_value
      [@loan_bonus_contract.remaining_balance, @financial_transaction_bonus.cent_amount].min
    end

    def paid_bonus_to_contract_user_sponsors
      deposit_product = Product.deposit.first
      temp_order = build_loan_payment_order_with(deposit_product)
      Bonification::BonusPropagatorService.call(order: temp_order,
                                                products: [deposit_product])
    end

    def build_loan_payment_order_with(product)
      order = Order.new(user: @loan_bonus_contract.user, loan_payment: true)
      order.order_items.build(product: product,
                              quantity: @financial_transaction_bonus.cent_amount.to_i)
      order
    end

    def upgrade_loan_contract_to_rentability_contract
      @loan_bonus_contract.cent_amount = 2 * @loan_bonus_contract.cent_amount.to_f.abs
      @loan_bonus_contract.rentability = (@loan_bonus_contract.cent_amount / @rentability_days_count).round(2)
      @loan_bonus_contract.remaining_balance = @loan_bonus_contract.cent_amount - @loan_bonus_contract.received_balance
      @loan_bonus_contract.expire_at = @rentability_days_count.days.from_now
      @loan_bonus_contract.loan = false
      @loan_bonus_contract.inactived_loan_at = DateTime.current
      @loan_bonus_contract.save!
    end

  end
end
