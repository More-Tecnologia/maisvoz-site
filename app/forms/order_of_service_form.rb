class OrderOfServiceForm < Form

  attribute :document_cpf
  attribute :car_plate
  attribute :created_by

  attribute :os_number
  attribute :gross_sales_str
  attribute :net_sales_str
  attribute :gross_service_str
  attribute :net_service_str

  validates :os_number, :gross_sales_str, :net_sales_str, :gross_service_str, :net_service_str, presence: true
  # validates :gross_sales_str, :net_sales_str, :gross_service_str, :net_service_str, numericality: { greater_than_or_equal_to: 1.0 }

  validate :os_number_unique
  validate :score_greater_than_zero
  validate :user_exists

  def user
    if document_cpf.present?
      User.find_by(document_cpf: document_cpf)
    elsif car_plate.present?
      ClubMotorsSubscription.find_by(plate: car_plate)&.user
    end
  end

  def profit
    return 0 if gross_sales_str.blank? || net_sales_str.blank? || gross_service_str.blank? || net_service_str.blank?

    (gross_sales - net_sales) + (gross_service - net_service)
  end

  def total_score
    (profit / 4).to_i
  end

  def gross_sales
    str_to_float(gross_sales_str)
  end

  def net_sales
    str_to_float(net_sales_str)
  end

  def gross_service
    str_to_float(gross_service_str)
  end

  def net_service
    str_to_float(net_service_str)
  end

  private

  def os_number_unique
    return unless OrderOfService.where(os_number: os_number).any?
    errors.add(:os_number, 'esta OS já consta no banco de dados')
  end

  def score_greater_than_zero
    return if total_score >= 0
    errors.add(:os_number, 'quantidade de PVV inválida, deve ser maior que 0')
  end

  def str_to_float(value)
    return 0 if value.blank?
    value.gsub('.', '').gsub(',','.').to_d
  end

  def user_exists
    return if user.present?
    errors.add(:document_cpf, 'usuário inexistente')
  end

end
