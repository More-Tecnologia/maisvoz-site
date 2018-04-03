# == Schema Information
#
# Table name: withdrawals
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  status               :string           not null
#  gross_amount_cents   :integer          not null
#  net_amount_cents     :integer          not null
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
