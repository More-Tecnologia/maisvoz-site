# == Schema Information
#
# Table name: subscriptions
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :bigint(8)
#  subscriptionable_type :string
#  subscriptionable_id   :bigint(8)
#  status                :string
#  current_period_start  :datetime
#  current_period_end    :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_subscriptionable_id_and_type  (subscriptionable_type,subscriptionable_id)
#  index_subscriptions_on_user_id      (user_id)
#

class Subscription < ApplicationRecord

  belongs_to :user
  belongs_to :club_motors_fee

end
