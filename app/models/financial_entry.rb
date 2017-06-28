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

class FinancialEntry < ApplicationRecord

  serialize :metadata, FinancialEntryMetadata

  enum kind: [:ecommerce]

  belongs_to :from, class_name: 'Account', optional: true
  belongs_to :to, class_name: 'Account'

  monetize :credit_cents
  monetize :debit_cents

  scope :credits, -> { where(type: 'CreditEntry') }
  scope :debits, -> { where(type: 'DebitEntry') }

  def from_user
    return unless from
    from.user
  end

end
