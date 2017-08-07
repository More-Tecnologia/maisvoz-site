# == Schema Information
#
# Table name: pv_activity_histories
#
#  id           :integer          not null, primary key
#  order_id     :integer          not null
#  amount_cents :integer          not null
#  user_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pv_activity_histories_on_order_id  (order_id)
#  index_pv_activity_histories_on_user_id   (user_id)
#

class PvActivityHistory < ApplicationRecord

  belongs_to :order
  belongs_to :user

  monetize :amount_cents

end
