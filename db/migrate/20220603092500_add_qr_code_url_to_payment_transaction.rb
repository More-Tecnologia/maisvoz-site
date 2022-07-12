# frozen_string_literal: true

class AddQrCodeUrlToPaymentTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_transactions, :qr_code_url, :string, default: ''
  end
end
