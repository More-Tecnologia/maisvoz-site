# == Schema Information
#
# Table name: categories
#
#  id             :bigint(8)        not null, primary key
#  name           :string
#  description    :string
#  order          :integer          default(0)
#  active_session :boolean          default(TRUE)
#  active         :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Category < ApplicationRecord

  has_many :products

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true).order(:order) }
  scope :sim_card, -> { where(code: 10) }
  scope :cellphone_reload, -> { where(code: 11) }

end
