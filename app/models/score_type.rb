class ScoreType < ApplicationRecord
  has_many :scores

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
end
