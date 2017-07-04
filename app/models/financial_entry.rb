# == Schema Information
#
# Table name: financial_entries
#
#  id           :integer          not null, primary key
#  description  :string
#  amount_cents :integer          default("0"), not null
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
#  index_financial_entries_on_kind     (kind)
#  index_financial_entries_on_to_id    (to_id)
#

class FinancialEntry < ApplicationRecord

  delegate :user, to: :to, prefix: true, allow_nil: true
  delegate :user, to: :from, prefix: true, allow_nil: true

  serialize :metadata, FinancialEntryMetadata

  enum kind: [:transfer, :credit_by_admin, :debit_by_admin, :tax, :withdrawal, :bonus, :bonus_chargeback, :product_return]

  belongs_to :from, class_name: 'Account', optional: true
  belongs_to :to, class_name: 'Account', optional: true

  monetize :amount_cents

  ransacker :date_created_at do
    Arel.sql("DATE(#{table_name}.created_at)")
  end

end
