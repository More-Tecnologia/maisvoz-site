class SimCard < ApplicationRecord

  enum statuses: [:in_stock, :sold]

  validates :iccid, presence: true,
                    uniqueness: true

  validates :phone_number, presence: true,
                           uniqueness: true,
                           numericality: { only_integer: true },
                           length: { minimum: 9, maximum: 13 }


end
