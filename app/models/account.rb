# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  balance_cents :integer          default("0"), not null
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id) UNIQUE
#

class Account < ApplicationRecord

  belongs_to :user

  monetize :balance_cents

end
