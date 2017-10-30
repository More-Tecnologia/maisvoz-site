# == Schema Information
#
# Table name: transfers
#
#  id           :integer          not null, primary key
#  from_user_id :integer          not null
#  to_user_id   :integer          not null
#  amount_cents :integer          not null
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
