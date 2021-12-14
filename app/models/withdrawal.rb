class Withdrawal < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :updater_user, class_name: 'User',
                            optional: true

  has_many :financial_transactions

  enum status: [:pending,  :approved, :approved_balance, :refused, :waiting, :canceled]
  enum payment_method: [:usd, :btc, :eth]

  def gross_amount_cents
    self[:gross_amount_cents] / 1e8.to_f if self[:gross_amount_cents]
  end

  def gross_amount_cents=(amount)
    self[:gross_amount_cents] = (amount * 1e8).to_i
  end

  def net_amount_cents
    self[:net_amount_cents] / 1e8.to_f if self[:net_amount_cents]
  end

  def net_amount_cents=(amount)
    self[:net_amount_cents] = (amount * 1e8).to_i
  end

  def crypto_amount
    self[:crypto_amount] / 1e8.to_f if self[:crypto_amount]
  end

  def crypto_amount=(amount)
    self[:crypto_amount] = (amount * 1e8).to_i
  end

  has_attachment :fiscal_document_photo

  ransacker :date_created_at do
    Arel.sql("DATE(#{table_name}.created_at)")
  end
end
