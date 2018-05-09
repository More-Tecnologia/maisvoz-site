# == Schema Information
#
# Table name: bonus
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)
#  order_id     :bigint(8)
#  kind         :string           not null
#  amount_cents :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_bonus_on_kind      (kind)
#  index_bonus_on_order_id  (order_id)
#  index_bonus_on_user_id   (user_id)
#

class Bonus < ApplicationRecord

  monetize :amount_cents

  enum kind: { binary: 'binary' }

  belongs_to :user
  belongs_to :order, optional: true

end
