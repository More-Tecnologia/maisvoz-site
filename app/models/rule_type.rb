class RuleType < ApplicationRecord
  has_many :rules
  
  validates :title, presence: true
  validates :description, presence: true
  validates :ruleable_name, presence: true,
                            uniqueness: { case_sensitive: false }
end
