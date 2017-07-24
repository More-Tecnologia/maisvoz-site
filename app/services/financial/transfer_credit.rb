module Financial
  class TransferCredit

    prepend SimpleCommand

    def initialize(from_user, params)
      @from_user = from_user
      @form = TransferWizard::TransferForm.new(params[:transfer_form].merge(from_user: from_user))
    end

    def call
      if form.valid?
        create_transfer
        return form
      else
        errors.add(:form, 'invalid')
      end
      nil
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

        # Atualiza apenas o available_balance da conta a ser creditada/debitada
        from_acc.available_balance_cents = from_acc.available_balance_cents - amount_cents
        to_acc.available_balance_cents = to_acc.available_balance_cents + amount_cents

        from_acc.save!
        to_acc.save!

        financial_entry.from = from_acc
        financial_entry.to = to_acc
        financial_entry.amount_cents = amount_cents
        financial_entry.save!
      end
    end

    def generate_metadata
      financial_entry.metadata = FinancialEntryMetadata.new(
        created_by_id: from_user.id,
        created_by_username: from_user.username,
        origin_account_available_balance_was: from_user.available_balance.to_s,
        dest_account_available_balance_was: form.to_user.available_balance.to_s
      )
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

    def amount_cents
      @amount_cents ||= (BigDecimal(form.amount) * 100).to_i
    end

  end
end
