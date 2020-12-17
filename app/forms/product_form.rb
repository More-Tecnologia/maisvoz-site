class ProductForm < Form
  attribute :id
  attribute :name
  attribute :description
  attribute :short_description
  attribute :sku
  attribute :quantity
  attribute :kind
  attribute :low_stock_alert
  attribute :weight
  attribute :length
  attribute :width
  attribute :height
  attribute :price
  attribute :binary_score
  attribute :advance_score
  attribute :active
  attribute :virtual
  attribute :paid_by
  attribute :binary_bonus
  attribute :main_photo
  attribute :photos
  attribute :category_id
  attribute :trail_id
  attribute :product_scores
  attribute :product_scores_fix
  attribute :financial_reason
  attribute :system_taxable
  attribute :shipping

  before_validation :assign_default_kind, if: proc { |f| f.product.blank? }

  validates :name, :quantity, :price, :kind, :binary_score, :category_id, presence: true

  validates :low_stock_alert, :binary_score, :advance_score,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :length, :width, :height, :weight, :price,
            numericality: { greater_than_or_equal_to: 0.0, allow_blank: true }

  def product
    @product ||= Product.find_by(id: id)
  end

  private

  def assign_default_kind
    @kind = :detached
  end
end
