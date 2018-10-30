# == Schema Information
#
# Table name: car_models
#
#  id                 :bigint(8)        not null, primary key
#  model_code         :integer
#  brand_code         :integer
#  fipe_code          :string
#  name               :string
#  type               :integer
#  club_motors_fee_id :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_car_models_on_brand_code          (brand_code)
#  index_car_models_on_club_motors_fee_id  (club_motors_fee_id)
#

class CarModel < ApplicationRecord

  self.inheritance_column = nil

  belongs_to :club_motors_fee, optional: true
  belongs_to :car_brand, class_name: 'CarBrand', foreign_key: :brand_code, primary_key: :brand_code

end
