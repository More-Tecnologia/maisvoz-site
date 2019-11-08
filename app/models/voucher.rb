# == Schema Information
#
# Table name: vouchers
#
#  id           :bigint(8)        not null, primary key
#  code         :string           not null
#  used         :boolean          default(FALSE), not null
#  user_id      :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :bigint(8)
#  invoice_type :string
#  used_at      :datetime
#
# Indexes
#
#  index_vouchers_on_code      (code) UNIQUE
#  index_vouchers_on_order_id  (order_id)
#  index_vouchers_on_user_id   (user_id)
#

class Voucher < ApplicationRecord

  include Hashid::Rails

  before_create :create_code

  belongs_to :user
  belongs_to :order, optional: true

  private

  def create_code
    loop do
      self.code = SecureRandom.hex[0, 12]
      break unless Voucher.exists?(code: self.code)
    end
  end

end
