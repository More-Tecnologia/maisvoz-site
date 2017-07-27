class CareerForm < Form

  attribute :public_id
  attribute :name
  attribute :qualifying_score
  attribute :bonus
  attribute :binary_limit
  attribute :kind

  validates :name, :qualifying_score, :bonus, :binary_limit, presence: true

end
