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

  validates :name, :quantity, :price, :kind, :binary_score, :category_id, presence: true

  validates :low_stock_alert, :binary_score, :advance_score, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :length, :width, :height, :weight, :price, 
            numericality: { greater_than_or_equal_to: 0.0, allow_blank: true }

  validate :sku_is_unique
  
  def scores(product_reason_score_id)
    ProductScore.joins(career_trail: :career, product_reason_score: :product)
      .where('products.id': id, 'career_trails.trail_id': trail_id, product_reason_score_id: product_reason_score_id)
      .order('generation ASC, careers.qualifying_score ASC')
      .distinct.select('product_scores.*, careers.qualifying_score')
  end

  def careers
    CareerTrail.joins(:career)
      .where(trail_id: trail_id)
      .order('careers.qualifying_score ASC')
  end

  private

  def sku_is_unique
    return if sku.blank?
    return unless Product.where(sku: sku).where.not(id: id).any?
    errors.add(:sku, I18n.t('defaults.errors.not_unique'))
  end

end
