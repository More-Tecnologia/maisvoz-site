# == Schema Information
#
# Table name: payment_transactions
#
#  id                     :bigint(8)        not null, primary key
#  order_id               :bigint(8)
#  user_id                :bigint(8)
#  boleto_url             :string
#  boleto_barcode         :string
#  boleto_expiration_date :datetime
#  status                 :string
#  pagarme_tid            :bigint(8)
#  amount_cents           :bigint(8)
#  paid_amount_cents      :bigint(8)        default(0)
#  installments           :integer          default(1)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  type                   :string
#  provider_response      :text
#
# Indexes
#
#  index_payment_transactions_on_order_id     (order_id)
#  index_payment_transactions_on_pagarme_tid  (pagarme_tid) UNIQUE WHERE (pagarme_tid IS NOT NULL)
#  index_payment_transactions_on_status       (status)
#  index_payment_transactions_on_type         (type)
#  index_payment_transactions_on_user_id      (user_id)
#

class PaymentTransaction < ApplicationRecord

  serialize :provider_response, JSON

  belongs_to :order
  belongs_to :user

end
