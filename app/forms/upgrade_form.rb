class UpgradeForm < Form

  attribute :subscription_id
  attribute :user

  validates :subscription_id, :user, presence: true

  def subscription
    Product.adhesion.find(subscription_id)
  end

  def total_cents
    subscription.price_cents - user.product.price_cents
  end

  def pv_total
    subscription.binary_score - user.product.binary_score
  end

end
