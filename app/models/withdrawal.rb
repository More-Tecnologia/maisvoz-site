# == Schema Information
#
# Table name: withdrawals
#
#  id           :integer          not null, primary key
#  amount_cents :integer          not null
#  status       :integer          not null
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_withdrawals_on_user_id  (user_id)
#

class Withdrawal < ApplicationRecord

  enum status: [:pending, :approved, :refused]

  belongs_to :user

  monetize :amount_cents

  ransacker :date_created_at do
    Arel.sql("DATE(#{table_name}.created_at)")
  end

end
