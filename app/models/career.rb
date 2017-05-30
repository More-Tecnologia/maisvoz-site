# == Schema Information
#
# Table name: careers
#
#  id               :integer          not null, primary key
#  name             :string
#  avatar           :string
#  qualifying_score :integer          default("0")
#  bonus            :integer          default("0")
#  binary_limit     :integer          default("0")
#  order            :integer          default("0")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Career < ApplicationRecord

  has_many :products

end
