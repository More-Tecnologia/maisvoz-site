# == Schema Information
#
# Table name: investments
#
#  id                :bigint(8)        not null, primary key
#  name              :string
#  total_cents       :bigint(8)        not null
#  price_cents       :bigint(8)        not null
#  shares_available  :integer          default(0)
#  shares_total      :integer          default(0)
#  investment_cycles :integer          default(0)
#  investment_yield  :decimal(5, 2)
#  details           :text
#  status            :string
#  address           :string
#  phone             :string
#  whatsapp          :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_investments_on_status  (status)
#

class Investment < ApplicationRecord

  self.inheritance_column = nil

  enum type: {
    fuel_station: 'fuel_station',
    auto_center: 'auto_center'
  }

  enum status: {
    pending: 'pending',
    active: 'active'
  }

  monetize :price_cents, :total_cents

  validates :shares_available, numericality: { greater_than_or_equal_to: 0 }

  validates :name, :address, :status, :type, presence: true

end
