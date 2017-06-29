module Financial
  class TransferCredit

    prepend SimpleCommand

    def initialize(from_user, params)
      @from_user = from_user
      @form = TransferForm.new(params[:transfer_form].merge(from_user: from_user))
    end

    def call
      if form.valid?
        create_transfer
      else
        errors.add(:form, 'invalid')
      end
      form
    end

    private

    attr_reader :from_user, :form

    def create_transfer
      ActiveRecord::Base.transaction do
        generate_metadata

        # Lock accounts involved on the txn
        from_acc = from_user.account
        to_acc = form.to_user.account

        from_acc.lock!
        to_acc.lock!

        # Atualiza apenas o balance da conta a ser creditada/debitada
        from_acc.balance_cents = from_acc.balance_cents - amount_cents
        to_acc.balance_cents = to_acc.balance_cents + amount_cents

        from_acc.save!
        to_acc.save!

        financial_entry.from = from_acc
        financial_entry.to = to_acc
        financial_entry.credit_cents = amount_cents
        financial_entry.save!
      end
    end

    def generate_metadata
      financial_entry.metadata = FinancialEntryMetadata.new(
        created_by_id: from_user.id,
        created_by_username: from_user.username,
        origin_account_balance_was: from_user.balance.to_s,
        dest_account_balance_was: form.to_user.balance.to_s
      )
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

    def amount_cents
      @amount_cents ||= BigDecimal(form.amount) * 100
    end

  end
end
