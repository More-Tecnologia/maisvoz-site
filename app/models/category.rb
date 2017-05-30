# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :string
#  order          :integer          default("0")
#  active_session :boolean          default("true")
#  active         :boolean          default("true")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Category < ApplicationRecord

  has_many :products

end
