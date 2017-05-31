class CareerForm < Form

  attribute :name
  attribute :avatar
  attribute :qualifying_score
  attribute :bonus
  attribute :binary_limit
  attribute :order

  validates :name, :qualifying_score, :bonus, :binary_limit, presence: true

end
