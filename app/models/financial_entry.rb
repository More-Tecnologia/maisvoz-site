# == Schema Information
#
# Table name: financial_entries
#
#  id            :integer          not null, primary key
#  description   :string
#  amount_cents  :integer          default(0), not null
#  balance_cents :integer          default(0), not null
#  kind          :string           default(NULL)
#  user_id       :integer
#  order_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_financial_entries_on_kind      (kind)
#  index_financial_entries_on_order_id  (order_id)
#  index_financial_entries_on_user_id   (user_id)
#

class FinancialEntry < ApplicationRecord

  include Hashid::Rails
  include FinancialTypes

  belongs_to :user
  belongs_to :order, optional: true

  monetize :amount_cents, :balance_cents

  ransacker :date_created_at do
    Arel.sql("DATE(#{table_name}.created_at)")
  end

end
