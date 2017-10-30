# == Schema Information
#
# Table name: accounts
#
#  id                      :integer          not null, primary key
#  available_balance_cents :integer          default(0), not null
#  blocked_balance_cents   :integer          default(0), not null
#  user_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id) UNIQUE
#

class Account < ApplicationRecord

  belongs_to :user

  has_many :origin_financial_entries, foreign_key: 'from_id'
  has_many :dest_financial_entries, foreign_key: 'to_id'

  monetize :available_balance_cents
  monetize :blocked_balance_cents

  def credits
    FinancialEntry.where(to_id: id)
  end

  def debits
    FinancialEntry.where(from_id: id)
  end

end
