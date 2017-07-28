module Financial
  class CreateCreditDebit

    prepend SimpleCommand

    def initialize(from_user, params)
      @from_user = from_user
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

    attr_reader :from_user, :form

    def create_credit_debit
      ActiveRecord::Base.transaction do
        generate_metadata

        account = form.user.account
        account.lock!

        # Atualiza apenas o balance da conta a ser creditada/debitada
        account.available_balance_cents += form.credit? ? amount_in_cents : -amount_in_cents
        account.save!

        if form.credit?
          financial_entry.to = form.user.account
          financial_entry.credit_by_admin!
        else
          financial_entry.from = form.user.account
          financial_entry.debit_by_admin!
        end
        financial_entry.amount_cents = amount_in_cents
        financial_entry.save!
      end
    end

    def generate_metadata
      financial_entry.metadata = FinancialEntryMetadata.new(
        created_by_id: from_user.id,
        created_by_username: from_user.username,
        dest_account_available_balance_was: form.user.account.available_balance.to_s
      )
    end

    def amount_in_cents
      @amount_in_cents ||= (BigDecimal(form.amount) * 100).to_i
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

  end
end
