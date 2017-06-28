# == Schema Information
#
# Table name: financial_entries
#
#  id           :integer          not null, primary key
#  description  :string
#  credit_cents :integer          default("0"), not null
#  debit_cents  :integer          default("0"), not null
#  type         :string
#  kind         :integer          default("0")
#  metadata     :jsonb            not null
#  from_id      :integer
#  to_id        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_financial_entries_on_from_id  (from_id)
#  index_financial_entries_on_to_id    (to_id)
#

class CreditEntry < FinancialEntry

  def amount_cents
    credit_cents
  end

  def amount
    credit_cents / 100.0
  end

  def amount_cents=(value)
    self.credit_cents = value
  end

  def amount=(value)
    self.credit_cents = value * 100
  end

end
