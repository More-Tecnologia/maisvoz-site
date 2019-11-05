class ScoreType < ApplicationRecord
  
  has_many :scores
  has_many :rule_ruleables, as: :ruleable
  has_many :rules, through: :rule_ruleables

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  enum tree_type: [:unilevel, :binary]

  def self.binary_score
    find_by(id: 4)
  end

  def self.binary_unqualified_chargeback
    find_by(id: 5)
  end

  def self.inactivity_chargeback
    find_by(id: 6)
  end

  def self.binary_bonus_debit
    find_by(id: 7)
  end

end
