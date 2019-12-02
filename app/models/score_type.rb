class ScoreType < ApplicationRecord

  has_many :scores
  has_many :rule_ruleables, as: :ruleable
  has_many :rules, through: :rule_ruleables

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  enum tree_type: [:unilevel, :binary]

  def self.adhesion
    find_by(code: '100')
  end

  def self.activation
    find_by(code: '200')
  end

  def self.detached
    find_by(code: '300')
  end

  def self.binary_score
    find_by(id: '400')
  end

  def self.binary_unqualified_chargeback
    find_by(id: '500')
  end

  def self.inactivity_chargeback
    find_by(id: '600')
  end

  def self.binary_bonus_debit
    find_by(id: '700')
  end

  def self.unilevel_inactivity_chargeback
    find_by(code: '800')
  end

end
