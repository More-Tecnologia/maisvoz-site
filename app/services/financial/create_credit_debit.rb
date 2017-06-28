module Financial
  class CreateCreditDebit

    prepend SimpleCommand

    def initialize(from_user, params)
      @from_user = from_user
      @form = CreditDebitForm.new(params[:credit_debit_form])
    end

    def call
      if form.valid?
        create_credit_debit
      else
        errors.add(:form, 'invalid')
      end
      form
    end

    private

    attr_reader :from_user, :form

    def create_credit_debit
      ActiveRecord::Base.transaction do
        generate_metadata

        account = form.user.account
        account.lock!

        # Atualiza apenas o balance da conta a ser creditada/debitada
        account.balance_cents += form.credit? ? amount_in_cents : -amount_in_cents
        account.save!

        resource.to = form.user.account
        resource.amount_cents = amount_in_cents
        resource.save!
      end
    end

    def generate_metadata
      resource.metadata = FinancialEntryMetadata.new(
        created_by_id: from_user.id,
        created_by_username: from_user.username,
        dest_account_balance_was: form.user.account.balance.to_s
      )
    end

    def amount_in_cents
      @amount_in_cents ||= BigDecimal(form.amount) * 100
    end

    def resource
      @resource ||= form.credit? ? CreditEntry.new : DebitEntry.new
    end

  end
end
