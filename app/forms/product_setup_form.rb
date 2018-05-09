class ProductSetupForm < Form

  attribute :installer
  attribute :name
  attribute :document_cpf
  attribute :phone
  attribute :email
  attribute :car_brand
  attribute :car_year
  attribute :car_model
  attribute :car_mileage
  attribute :car_plate
  attribute :product_id
  attribute :product_serial

  attribute :checkin
  attribute :checkout
  attribute :installation

  validates :name, :document_cpf, :phone, :email, :car_brand, :car_year,
            :car_model, :car_mileage, :car_plate, :product_id,
            :product_serial, presence: true

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def product
    Product.find(product_id)
  end

end
