class ProductForm < Form

  attribute :id
  attribute :name
  attribute :description
  attribute :short_description
  attribute :sku
  attribute :quantity
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
  attribute :category_id
  attribute :career_id
  attribute :bonus_1
  attribute :bonus_2
  attribute :bonus_3
  attribute :bonus_4
  attribute :bonus_5
  attribute :bonus_6
  attribute :bonus_7
  attribute :bonus_8
  attribute :bonus_9

  attribute :public_id_cache
  attribute :public_id

  validates :name, :quantity, :price, :binary_score, :category_id, :career_id, presence: true

  validates :quantity, :low_stock_alert, :length, :width, :height, :binary_score,
            :advance_score, :bonus_1, :bonus_2, :bonus_3, :bonus_4, :bonus_5, :bonus_6, :bonus_7,
            :bonus_8, :bonus_9,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :weight, :price, numericality: { greater_than_or_equal_to: 0.0, allow_blank: true }

  validate :sku_is_unique

  private

  def sku_is_unique
    return if sku.blank?
    return unless Product.where(sku: sku).where.not(id: id).any?
    errors.add(:sku, I18n.t('defaults.error.not_unique'))
  end

end
