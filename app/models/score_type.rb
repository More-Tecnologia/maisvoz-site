class ScoreType < ApplicationRecord
  has_many :scores

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  enum tree_type: [:unilevel, :binary]
end
