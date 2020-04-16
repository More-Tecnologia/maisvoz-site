class ScoreType < ApplicationRecord

  has_many :scores
  has_many :rule_ruleables, as: :ruleable
  has_many :rules, through: :rule_ruleables

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   uniqueness: true

  enum tree_type: [:unilevel, :binary]

  scope :active, -> { where(active: true) }

  def self.adhesion
    find_by(code: '100')
  end

  def self.activation
    find_by(code: '200')
  end

  def self.detached
    find_by(code: '300')
  end

  def self.deposit
    @@deposit ||= find_by(code: '1000')
  end

  def self.binary_score
    @@binary_score ||= find_by(code: '400')
  end

  def self.binary_unqualified_chargeback
    find_by(code: '500')
  end

  def self.inactivity_chargeback
    find_by(code: '600')
  end

  def self.binary_bonus_debit
    find_by(code: '700')
  end

  def self.unilevel_inactivity_chargeback
    find_by(code: '800')
  end

  def self.pool_point
    @@pool_point ||= find_by(code: '900')
  end

end
