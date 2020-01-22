class CareerForm < Form

  attribute :name
  attribute :qualifying_score
  attribute :bonus
  attribute :binary_limit
  attribute :binary_percentage
  attribute :kind
  attribute :career_id
  attribute :unilevel_qualifying_career_id
  attribute :unilevel_qualifying_career
  attribute :unilevel_qualifying_career_count
  attribute :lineage_score
  attribute :requalification_score

  validates :name, :qualifying_score, :bonus, :binary_limit, :binary_percentage,
            :kind, presence: true

  def unilevel_qualifying_career
    Career.find_by(id: unilevel_qualifying_career_id)
  end

end
