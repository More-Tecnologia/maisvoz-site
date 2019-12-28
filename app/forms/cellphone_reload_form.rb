class CellphoneReloadForm < Form

  attribute :product_id
  attribute :ddd
  attribute :cellphone_number

  validates :product_id, presence: true
  validates :ddd, presence: true, numericality: true,
                                  length: { is: 2 }
  validates :cellphone_number, numericality: true,
                               length: { is: 9 },
                               presence: true
  validates :product, presence: true

  before_validation :cleasing

  def product
    @product ||= Product.find_by(id: product_id)
  end

  private

  def cleasing
    @cellphone_number = cellphone_number.to_s.gsub(/\D/,'')
  end

end
