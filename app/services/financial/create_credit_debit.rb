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
        update_available_balance
        create_system_financial_log
      end
    end

    private

    attr_reader :spreader, :form, :user

    def create_financial_transaction
      user.financial_transactions.create!(spreader: spreader,
                                          financial_reason: form.financial_reason,
                                          amount_cents: form.amount,
                                          moneyflow: find_moneyflow)
    end

    def find_moneyflow
      form.credit? ? :credit : :debit
    end

    def update_available_balance
      return user.increment!(:available_balance_cents, form.amount) if form.credit?
      user.decrement!(:available_balance_cents, form.amount)
    end

    def create_system_financial_log
      amount = form.credit? ? -form.amount : form.amount
      SystemFinancialLog.new.tap do |entry|
        entry.description  = form.financial_reason.title
        entry.amount_cents = amount
        entry.kind = form.credit? ? SystemFinancialLog.kinds[:credit_by_admin] : SystemFinancialLog.kinds[:debit_by_admin]
        entry.save!
      end
    end

    def valid_form?
      return true if form.valid?
      errors.add(:form, form.errors.full_messages)
    end
  end
end
