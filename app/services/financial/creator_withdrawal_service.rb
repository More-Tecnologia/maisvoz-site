module Financial
  class CreatorWithdrawalService < ApplicationService

    def call
      ActiveRecord::Base.transaction do
        create_withdrawal
        increment_withdrawal_order_amount_from_user
      end
    end

    private

    attr_reader :form, :user

    def initialize(args)
      @form = args[:form]
      @user = form.user
    end

    def create_withdrawal
      return unless form.amount_cents.to_f > 0
      user.withdrawals.create!(gross_amount_cents: form.amount_cents,
                               net_amount_cents: form.net_amount_cents,
                               fiscal_document_link: form.fiscal_document_link,
                               fiscal_document_photo: form.fiscal_document_photo)
    end

    def increment_withdrawal_order_amount_from_user
      user.update!(withdrawal_order_amount: user.withdrawal_order_amount + form.amount_cents)
    end

  end
end