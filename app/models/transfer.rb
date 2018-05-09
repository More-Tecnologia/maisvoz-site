# == Schema Information
#
# Table name: transfers
#
#  id           :bigint(8)        not null, primary key
#  from_user_id :bigint(8)        not null
#  to_user_id   :bigint(8)        not null
#  amount_cents :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_transfers_on_from_user_id  (from_user_id)
#  index_transfers_on_to_user_id    (to_user_id)
#

class Transfer < ApplicationRecord

  monetize :amount_cents

  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

end
