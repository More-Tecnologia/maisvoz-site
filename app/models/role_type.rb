class RoleType < ApplicationRecord

  has_many :users, foreign_key: 'role_type_code',
                   primary_key: 'role_type_code'

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   uniqueness: true,
                   numericality: { only_integer: true,
                                   greater_than: 0 }

  def self.support_point_code
    10
  end

end
