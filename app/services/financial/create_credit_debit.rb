module Financial
  class CreateCreditDebit

    prepend SimpleCommand

    def initialize(spreader, params)
      @spreader = spreader
      @form = CreditDebitWizard::CreateForm.new(params[:credit_debit_form])
      @user = @form.user
    end

    def call
      return unless valid_form?
      ActiveRecord::Base.transaction do
        create_financial_transaction
      end
    end

    private

    attr_reader :spreader, :form, :user

    def create_financial_transaction
      user.financial_transactions.create!(spreader: spreader,
                                          note: form.note,
                                          cent_amount: form.amount,
                                          moneyflow: find_moneyflow,
                                          financial_reason: find_financial_reason) if form.amount > 0
    end

    def find_moneyflow
      form.credit? ? :credit : :debit
    end

    def find_financial_reason
      return FinancialReason.credit_reason if form.credit?
      FinancialReason.debit_reason
    end

    def valid_form?
      return true if form.valid?
      errors.add(:form, form.errors.full_messages)
    end

  end
end
