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
      Credit.new.tap do |credit|
        credit.operated_by  = operated_by
        credit.user         = form.user
        credit.message      = form.message
        credit.amount_cents = amount_in_cents
        credit.save!
      end
    end

    def create_debit
      Debit.new.tap do |debit|
        debit.operated_by  = operated_by
        debit.user         = form.user
        debit.message      = form.message
        debit.amount_cents = amount_in_cents
        debit.save!
      end
    end

    def amount_in_cents
      @amount_in_cents ||= (BigDecimal(form.amount) * 100).to_i
    end

  end
end
