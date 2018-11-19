# == Schema Information
#
# Table name: car_brands
#
#  id         :bigint(8)        not null, primary key
#  brand_code :integer          not null
#  name       :string
#  type       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_car_brands_on_brand_code  (brand_code) UNIQUE
#

class CarBrand < ApplicationRecord

  self.inheritance_column = nil

  has_many :car_models, foreign_key: :brand_code, primary_key: :brand_code

end
