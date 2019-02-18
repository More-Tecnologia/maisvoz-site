# == Schema Information
#
# Table name: investment_shares
#
#  id                  :bigint(8)        not null, primary key
#  investment_id       :bigint(8)
#  user_id             :bigint(8)
#  quantity            :integer          not null
#  name                :string
#  status              :string
#  gross_amount_cents  :bigint(8)
#  net_amount_cents    :bigint(8)
#  bonus_cycle         :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  profit_amount_cents :bigint(8)        default(0), not null
#  next_bonus_payment  :date
#
# Indexes
#
#  index_investment_shares_on_investment_id  (investment_id)
#  index_investment_shares_on_user_id        (user_id)
#

class InvestmentShare < ApplicationRecord

  monetize :gross_amount_cents, :net_amount_cents, :profit_amount_cents

  has_many :orders, as: :payable

  belongs_to :investment
  belongs_to :user

  enum status: {
    pending: 'pending',
    active: 'active',
    finished: 'finished',
    expired_payment: 'expired_payment'
  }

  delegate :name, to: :investment

  def type
    name
  end

  def bonus_amount
    @bonus_amount ||= (investment.investment_yield / 100.0) * gross_amount
  end

end
