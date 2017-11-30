# == Schema Information
#
# Table name: system_financial_logs
#
#  id           :integer          not null, primary key
#  description  :string
#  amount_cents :integer
#  kind         :string
#  order_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_system_financial_logs_on_order_id  (order_id)
#

class SystemFinancialLog < ApplicationRecord

  include FinancialTypes

  belongs_to :order, optional: true

  monetize :amount_cents

end
