# == Schema Information
#
# Table name: pv_histories
#
#  id              :bigint(8)        not null, primary key
#  order_id        :bigint(8)
#  direction       :string           default("left"), not null
#  amount_cents    :bigint(8)        default(0), not null
#  balance_cents   :bigint(8)        default(0), not null
#  user_id         :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  origin_username :string
#
# Indexes
#
#  index_pv_histories_on_order_id  (order_id)
#  index_pv_histories_on_user_id   (user_id)
#

class PvHistory < ApplicationRecord

  include Hashid::Rails

  belongs_to :order, optional: true
  belongs_to :user

  enum direction: { left: 'left', right: 'right' }

  monetize :amount_cents
  monetize :balance_cents

end
