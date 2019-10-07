class ScoreType < ApplicationRecord
  has_many :scores
  has_many :rule_ruleables, as: :ruleable
  has_many :rules, through: :rule_ruleables

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  enum tree_type: [:unilevel, :binary]

  scope :by_tree_types, -> (tree_types) { where(tree_type: tree_types) }
end
