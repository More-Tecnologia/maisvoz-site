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

  enum status: { pending: 'pending', approved: 'approved', refused: 'refused' }

  belongs_to :user

  monetize :gross_amount_cents, :net_amount_cents

  has_attachment :fiscal_document_photo

  ransacker :date_created_at do
    Arel.sql("DATE(#{table_name}.created_at)")
  end

end
