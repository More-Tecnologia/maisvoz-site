class Rule < ApplicationRecord
  belongs_to :rule_type

  has_many :rule_ruleables
  has_many :score_types, through: :rule_ruleables,
                         source: :ruleable,
                         source_type: 'ScoreType'

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :description, presence: true
end
