module Financial
  class CreateCreditDebit

    prepend SimpleCommand

    def initialize(operated_by, params)
      @operated_by = operated_by
      @form = CreditDebitWizard::CreateForm.new(params[:credit_debit_form])
    end

    def call
      if form.valid?
        create_credit_debit
        return form
      else
        errors.add(:form, form.errors)
      end
      nil
    end

    private

    attr_reader :operated_by, :form

    def create_credit_debit
      ActiveRecord::Base.transaction do
        form.credit? ? create_credit : create_debit
      end
    end

    def create_credit
      FinancialEntry.new.tap do |entry|
        entry.user          = form.user
        entry.description   = form.message
        entry.kind          = FinancialEntry.kinds[:credit_by_admin]
        entry.amount_cents  = amount_in_cents
        entry.balance_cents = form.user.balance_cents + amount_in_cents
        entry.save!
      end
      form.user.increment!(:available_balance_cents, amount_in_cents)
      create_system_financial_log(-amount_in_cents)
    end

    def create_debit
      FinancialEntry.new.tap do |entry|
        entry.user          = form.user
        entry.description   = form.message
        entry.kind          = FinancialEntry.kinds[:debit_by_admin]
        entry.amount_cents  = -amount_in_cents
        entry.balance_cents = form.user.balance_cents - amount_in_cents
        entry.save!
      end
      form.user.decrement!(:available_balance_cents, amount_in_cents)
      create_system_financial_log(amount_in_cents)
    end

    def create_system_financial_log(amount_cents)
      SystemFinancialLog.new.tap do |entry|
        entry.description  = form.message
        entry.amount_cents = amount_cents
        entry.kind = form.credit? ? SystemFinancialLog.kinds[:credit_by_admin] : SystemFinancialLog.kinds[:debit_by_admin]
        entry.save!
      end
    end

    def amount_in_cents
      @amount_in_cents ||= (BigDecimal(form.amount) * 100).to_i
    end

  end
end
