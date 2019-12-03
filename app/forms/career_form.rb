class CareerForm < Form

  attribute :name
  attribute :qualifying_score
  attribute :bonus
  attribute :binary_limit
  attribute :binary_percentage
  attribute :kind
  attribute :career_id

  validates :name, :qualifying_score, :bonus, :binary_limit, :binary_percentage,
            :kind, presence: true

end
