# == Schema Information
#
# Table name: withdrawals
#
#  id                   :bigint(8)        not null, primary key
#  status               :string           not null
#  user_id              :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  gross_amount_cents   :bigint(8)        not null
#  net_amount_cents     :bigint(8)        not null
#  fiscal_document_link :string
#
# Indexes
#
#  index_withdrawals_on_status   (status)
#  index_withdrawals_on_user_id  (user_id)
#

class Withdrawal < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :updater_user, class_name: 'User',
                            optional: true

  has_many :financial_transactions

  enum status: [:pending,  :approved, :approved_balance, :refused, :waiting, :canceled]

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


  has_attachment :fiscal_document_photo

  ransacker :date_created_at do
    Arel.sql("DATE(#{table_name}.created_at)")
  end
end
