class Email < ApplicationRecord
  include Hashid::Rails

  enum status: { pending: 0, active: 1, inactive: 2 }

  belongs_to :user

  validates :body, presence: true, email: true
end
