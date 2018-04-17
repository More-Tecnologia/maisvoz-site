# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
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

  default_scope { where(active: true).order(:order) }
  scope :active, -> { where(active: true) }

end
