# == Schema Information
#
# Table name: payment_transactions
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
#  type                   :string
#  provider_response      :text
#
# Indexes
#
#  index_payment_transactions_on_order_id     (order_id)
#  index_payment_transactions_on_pagarme_tid  (pagarme_tid) UNIQUE
#  index_payment_transactions_on_status       (status)
#  index_payment_transactions_on_type         (type)
#  index_payment_transactions_on_user_id      (user_id)
#

class BradescoTransaction < PaymentTransaction

  enum status: BradescoTransactionType.enum

  validates :status, presence: true, inclusion: { in: BradescoTransactionType.all }

  def paid?
    status == BradescoTransactionType::PAID_MANUAL ||
    status == BradescoTransactionType::PAID_MORE ||
    status == BradescoTransactionType::PAID_EQUAL
  end

end
