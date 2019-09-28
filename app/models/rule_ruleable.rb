class RuleRuleable < ApplicationRecord
  belongs_to :rule
  belongs_to :ruleable, polymorphic: true
end
