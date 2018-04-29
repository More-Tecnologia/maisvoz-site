# == Schema Information
#
# Table name: pagarme_transactions
#
#  id                     :integer          not null, primary key
#  order_id               :integer
#  user_id                :integer
#  boleto_url             :string
#  boleto_barcode         :string
#  boleto_expiration_date :datetime
#  status                 :string
#  pagarme_tid            :integer
#  amount_cents           :integer
#  paid_amount_cents      :integer          default(0)
#  installments           :integer          default(1)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_pagarme_transactions_on_order_id     (order_id)
#  index_pagarme_transactions_on_pagarme_tid  (pagarme_tid) UNIQUE
#  index_pagarme_transactions_on_status       (status)
#  index_pagarme_transactions_on_user_id      (user_id)
#

class PagarmeTransaction < ApplicationRecord

  enum status: PagarmeTransactionType.enum

  validates :status, presence: true, inclusion: { in: PagarmeTransactionType.all }

  belongs_to :order
  belongs_to :user

end
