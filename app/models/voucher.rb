# == Schema Information
#
# Table name: vouchers
#
#  id                          :bigint(8)        not null, primary key
#  code                        :string           not null
#  used                        :boolean          default(FALSE), not null
#  user_id                     :bigint(8)
#  club_motors_subscription_id :bigint(8)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_vouchers_on_club_motors_subscription_id  (club_motors_subscription_id)
#  index_vouchers_on_code                         (code) UNIQUE
#  index_vouchers_on_user_id                      (user_id)
#

class Voucher < ApplicationRecord

  before_create :create_code

  belongs_to :user
  belongs_to :club_motors_subscription, optional: true

  private

  def create_code
    loop do
      self.code = SecureRandom.hex[0, 6]
      break unless Voucher.exists?(code: self.code)
    end
  end

end
