class ClubMotorsSubscriptionForm < Form

  attribute :id
  attribute :user
  attribute :car_brand_id
  attribute :car_model_id
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
  attribute :terms_of_service
  attribute :plan_package
  attribute :assistance_24h

  validates :car_brand_id, presence: true, if: :new_vehicle?
  validates :car_model_id, presence: true, if: :new_vehicle?
  validates :plate, presence: true, if: :new_vehicle?
  validates :chassis, presence: true
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
  validates :plan_package, presence: true
  validates :plate, length: { is: 7 }
  validates :terms_of_service, acceptance: true

  validate :verify_plate_unique, if: :new_vehicle?

  def plate=(attr)
    super attr.upcase
  end

  def car_models_list
    @car_models_list ||= CarModel.where(
      brand_code: car_brand_id
    ).where.not(club_motors_fee: nil).order(:name).select(:id, :name)
  end

  def adhesion_fee_list
    return [] if club_motors_fee.blank?
    [
      { name: 'gold', price: club_motors_fee.premium_fee_cents / 1e2 },
      { name: 'silver', price: club_motors_fee.master_fee_cents / 1e2 },
      { name: 'bronze', price: club_motors_fee.standard_fee_cents / 1e2 }
    ]
  end

  def assistance_24h_price
    return 0 if assistance_24h.blank?

    prices = {
      gold: 25,
      silver: 20,
      bronze: 15
    }

    prices[plan_package.to_sym]
  end

  def monthly_fee
    return if car_brand.blank? || car_model.blank? || plan_package.blank?

    adhesion_fee_list.select {|i| i[:name] == plan_package}[0][:price] + assistance_24h_price
  end

  def club_motors_fee
    return nil if car_model.blank?

    car_model.club_motors_fee
  end

  def car_brand
    return if car_brand_id.blank?

    @car_brand ||= CarBrand.find_by(brand_code: car_brand_id)
  end

  def car_model
    return if car_brand.blank?
    return unless car_model_exist?

    @car_model ||= CarModel.find(car_model_id)
  end

  def car_model_exist?
    @car_model_exist ||= car_brand.car_models.exists?(id: car_model_id)
  end

  def club_motors_list
    @club_motors_list ||= Product.active.club_motors.order(:price_cents)
  end

  def edit_attributes
    attributes.except(:id, :user, :car_brand_id, :car_model_id, :terms_of_service, :plate)
  end

  def create_attributes
    attributes.except(:id, :car_brand_id, :terms_of_service)
  end

  def new_vehicle?
    id.blank?
  end

  def verify_plate_unique
    return unless ClubMotorsSubscription.clubmotors.exists?(plate: plate)

    errors.add(:plate, 'Esta placa já consta em nosso banco de dados')
  end

end
