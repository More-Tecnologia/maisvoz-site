module Financial
  class CreatorWithdrawalService < ApplicationService
    PAYMENT_METHOD = {
      'bitcoin' => 'wallet_address',
      'pix' => 'pix_wallet'
    }

    def call
      ActiveRecord::Base.transaction do
        ensure_payment_method
        create_withdrawal
        increment_withdrawal_order_amount_from_user
      end
      notify_withdrawal_user_by_email
    end

    private

    attr_reader :form, :user, :payment_method

    def initialize(args, locale)
      @form = args[:form]
      @user = form.user
      @locale = locale
      @payment_method = form.payment_method
    end

    def create_withdrawal
      return unless form.amount_cents.to_f > 0
      @withdrawal = user.withdrawals.create!(gross_amount_cents: form.amount_cents,
                                             net_amount_cents: form.net_amount_cents,
                                             fiscal_document_link: form.fiscal_document_link,
                                             fiscal_document_photo: form.fiscal_document_photo,
                                             status: :waiting)
    end

    def ensure_payment_method
      raise I18n.t(:no_payment_method_selected) unless payment_method.in?(%w[pix bitcoin])
      raise I18n.t(:no_address_input, payment_type_address: payment_method.capitalize) if payment_address.blank?

      update_wallet_addresses
    end

    def increment_withdrawal_order_amount_from_user
      user.update!(withdrawal_order_amount: user.withdrawal_order_amount + form.amount_cents)
    end

    def notify_withdrawal_user_by_email
      WithdrawalsMailer.with(withdrawal: @withdrawal, locale: @locale)
                       .waiting
                       .deliver_later
    end

    def payment_type_address
      PAYMENT_METHOD[payment_method]
    end

    def payment_address
      form[payment_type_address]
    end

    def update_wallet_addresses
      user.update(payment_type_address => payment_address)
    end

  end
end
