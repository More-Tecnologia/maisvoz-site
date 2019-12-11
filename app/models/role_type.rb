class RoleType < ApplicationRecord

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   uniqueness: true,
                   numericality: { only_integer: true,
                                   greater_than: 0 }


end
