class Rule < ApplicationRecord
  belongs_to :rule_type

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :description, presence: true
end
