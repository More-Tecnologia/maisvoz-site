# == Schema Information
#
# Table name: product_setups
#
#  id                :bigint(8)        not null, primary key
#  installer_id      :bigint(8)
#  name              :string
#  document_cpf      :string
#  phone             :string
#  email             :string
#  car_brand         :string
#  car_year          :string
#  car_model         :string
#  car_mileage       :string
#  car_plate         :string
#  product_model     :string
#  product_serial    :string
#  status            :string
#  status_message    :string
#  status_updated_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_product_setups_on_installer_id  (installer_id)
#

class ProductSetup < ApplicationRecord

  include Hashid::Rails

  enum status: { pending: 'pending', in_analysis: 'in_analysis', refused: 'refused', approved: 'approved' }

  belongs_to :installer, class_name: 'User', foreign_key: 'installer_id'

  validates :name, :document_cpf, :phone, :email, :car_brand, :car_year,
            :car_model, :car_mileage, :car_plate, :product_model,
            :product_serial, presence: true
  
  validates :checkin, :checkout, :scanner_in, :scanner_out, :installation, presence: true

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

end
