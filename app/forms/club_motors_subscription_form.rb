class ClubMotorsSubscriptionForm < Form

  attribute :user
  attribute :car_brand
  attribute :car_model
  attribute :chassis
  attribute :plate
  attribute :cnpj_cpf
  attribute :owner_name
  attribute :manufacture_year
  attribute :model_year
  attribute :fuel
  attribute :mileage
  attribute :renavam
  attribute :gearbox
  attribute :taxi
  attribute :mercosul_code
  attribute :color
  attribute :color_type
  attribute :origin

  validates :car_brand, presence: true
  validates :car_model, presence: true
  validates :chassis, presence: true
  validates :plate, presence: true
  validates :cnpj_cpf, presence: true
  validates :owner_name, presence: true
  validates :manufacture_year, presence: true
  validates :model_year, presence: true
  validates :fuel, presence: true
  validates :renavam, presence: true
  validates :taxi, presence: true
  validates :mercosul_code, presence: true
  validates :color, presence: true
  validates :color_type, presence: true
  validates :origin, presence: true

  def car_models_list
    @car_models_list ||= CarModel.where(brand_code: car_brand).where.not(club_motors_fee: nil).order(:name).select(:id, :name)
  end

end