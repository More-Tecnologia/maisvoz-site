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
  attribute :club_motors
  attribute :paid_by
  attribute :category_id
  attribute :career_id
  attribute :upgrade_from_career_id
  attribute :upgrade_to_career_id
  attribute :binary_bonus
  attribute :bonus_1
  attribute :bonus_2
  attribute :bonus_3
  attribute :bonus_4
  attribute :bonus_5
  attribute :bonus_6
  attribute :bonus_7
  attribute :bonus_8
  attribute :bonus_9
  attribute :main_photo
  attribute :photos

  validates :name, :quantity, :price, :kind, :binary_score, :category_id, presence: true

  validates :low_stock_alert, :binary_score, :advance_score, :bonus_1, :bonus_2,
            :bonus_3, :bonus_4, :bonus_5, :bonus_6, :bonus_7, :bonus_8, :bonus_9,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :length, :width, :height, :weight, :price, numericality: { greater_than_or_equal_to: 0.0, allow_blank: true }

  validate :sku_is_unique
  # validate :career_presence_on_adhesion

  private

  def sku_is_unique
    return if sku.blank?
    return unless Product.where(sku: sku).where.not(id: id).any?
    errors.add(:sku, I18n.t('defaults.errors.not_unique'))
  end

  def career_presence_on_adhesion
    return if kind != 'adhesion'
    return if career_id.present?
    errors.add(:career_id, I18n.t('defaults.errors.career_required'))
  end

end
