# == Schema Information
#
# Table name: moovi_integrations
#
#  id                          :bigint(8)        not null, primary key
#  payload                     :jsonb
#  club_motors_subscription_id :bigint(8)
#  placa                       :string
#  status                      :string
#  fipe_code                   :string
#  price                       :decimal(8, 2)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_moovi_integrations_on_club_motors_subscription_id  (club_motors_subscription_id)
#

class InspectionIntegration < ApplicationRecord
  belongs_to :club_motors_subscription
end
