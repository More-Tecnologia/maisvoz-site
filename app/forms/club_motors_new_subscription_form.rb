class ClubMotorsNewSubscriptionForm < Form

  attribute :user
  attribute :club_motors_id
  attribute :car_brand_id
  attribute :car_model_id
  attribute :plate
  attribute :terms_of_service

  validates :car_brand_id, presence: true
  validates :car_model_id, presence: true
  validates :club_motors_id, presence: true
  validates :plate, presence: true
  validates :terms_of_service, acceptance: true
  validates :plate, length: { is: 7 }

  validate :verify_plate_unique

  def plate=(attr)
    super attr.upcase
  end

  def car_models_list
    @car_models_list ||= CarModel.where(
      brand_code: car_brand_id
    ).where.not(club_motors_fee: nil).order(:name).select(:id, :name)
  end

  def monthly_fee
    return if car_brand.blank? || car_model.blank? || club_motors.blank?

    Subscriptions::CalculateClubMotorsFee.new(product: club_motors, fee: club_motors_fee).call / 1e2
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
    return unless car_brand.car_models.exists?(id: car_model_id)

    @car_model ||= car_brand.car_models.find(car_model_id)
  end

  def club_motors_list
    @club_motors_list ||= Product.active.club_motors.order(:price_cents)
  end

  def club_motors
    return if club_motors_id.blank?

    @club_motors ||= Product.find(club_motors_id)
  end

  private

  def verify_plate_unique
    return unless ClubMotorsSubscription.exists?(plate: plate)

    errors.add(:plate, 'Esta placa já consta em nosso banco de dados')
  end

end
