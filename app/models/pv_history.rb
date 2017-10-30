# == Schema Information
#
# Table name: pv_histories
#
#  id            :integer          not null, primary key
#  order_id      :integer
#  direction     :string           default("left"), not null
#  amount_cents  :integer          default(0), not null
#  balance_cents :integer          default(0), not null
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_pv_histories_on_order_id  (order_id)
#  index_pv_histories_on_user_id   (user_id)
#

class PvHistory < ApplicationRecord

  belongs_to :order, optional: true
  belongs_to :user

  enum direction: { left: 'left', right: 'right' }

  monetize :amount_cents
  monetize :balance_cents

end
