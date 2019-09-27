class RuleType < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :ruleable_name, presence: true,
                            uniqueness: { case_sensitive: false }
end
