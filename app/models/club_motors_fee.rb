# == Schema Information
#
# Table name: club_motors_fees
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  standard_fee_cents :integer
#  master_fee_cents   :integer
#  premium_fee_cents  :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ClubMotorsFee < ApplicationRecord
end
