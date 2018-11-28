class ClubMotorsEditSubscriptionForm < Form

  attribute :id
  attribute :user
  attribute :chassis
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
  validates :terms_of_service, acceptance: true

  def edit_attributes
    attributes.except(:id, :user, :terms_of_service)
  end

end
