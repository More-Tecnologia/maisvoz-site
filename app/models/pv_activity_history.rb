# == Schema Information
#
# Table name: pv_activity_histories
#
#  id                  :bigint(8)        not null, primary key
#  order_id            :bigint(8)
#  amount              :integer          not null
#  user_id             :bigint(8)        not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  balance             :bigint(8)        default(0), not null
#  kind                :string
#  height              :bigint(8)
#  order_of_service_id :bigint(8)
#
# Indexes
#
#  index_pv_activity_histories_on_order_id             (order_id)
#  index_pv_activity_histories_on_order_of_service_id  (order_of_service_id)
#  index_pv_activity_histories_on_user_id              (user_id)
#

class PvActivityHistory < ApplicationRecord

  include Hashid::Rails

  enum kind: { pvv: 'pvv', pvg: 'pvg', pvm: 'pvm' }

  belongs_to :order, optional: true
  belongs_to :order_of_service, optional: true
  belongs_to :user

  def from
    if order_id.present?
      order.user
    else
      order_of_service.user
    end
  end

end
