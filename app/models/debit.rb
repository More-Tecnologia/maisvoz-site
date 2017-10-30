# == Schema Information
#
# Table name: debits
#
#  id             :integer          not null, primary key
#  operated_by_id :integer
#  user_id        :integer          not null
#  message        :string
#  amount_cents   :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_debits_on_operated_by_id  (operated_by_id)
#  index_debits_on_user_id         (user_id)
#

class Debit < ApplicationRecord

  monetize :amount_cents

  belongs_to :operated_by, class_name: 'User'
  belongs_to :user

end
