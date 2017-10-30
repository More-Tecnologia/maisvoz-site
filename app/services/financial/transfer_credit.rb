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
        Transfer.new.tap do |transfer|
          transfer.from_user = from_user
          transfer.to_user = form.to_user
          transfer.amount_cents = amount_cents
          transfer.save!
        end
      end
    end

    def amount_cents
      @amount_cents ||= (BigDecimal(form.amount) * 100).to_i
    end

  end
end
