class NewTrackerForm < Form

  MONTHLY_FEE = 40.0

  attribute :user
  attribute :car_brand_id
  attribute :car_model_id
  attribute :plate
  attribute :terms_of_service

  validates :car_brand_id, presence: true
  validates :car_model_id, presence: true
  validates :plate, presence: true
  validates :terms_of_service, acceptance: true
  validates :plate, length: { is: 7 }

  validate :verify_plate_unique

  def car_models_list
    @car_models_list ||= CarModel.where(
      brand_code: car_brand_id
    ).order(:name).select(:id, :name)
  end

  def car_model
    CarModel.find(car_model_id)
  end

  def monthly_fee
    MONTHLY_FEE
  end

  def tracker_price
    Trackers::CalculateAdhesionPrice.new(user: user).call
  end

  def tracker_price_cents
    (tracker_price * 1e2).to_i
  end

  def tracker
    @tracker ||= Product.where(tracker: true).first
  end

  private

  def verify_plate_unique
    return unless ClubMotorsSubscription.tracker.exists?(plate: plate)

    errors.add(:plate, 'Esta placa já consta em nosso banco de dados')
  end

end
