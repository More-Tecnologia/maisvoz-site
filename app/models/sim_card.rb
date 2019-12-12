class SimCard < ApplicationRecord

  has_paper_trail

  belongs_to :user, optional: true
  belongs_to :order
  belongs_to :support_point_user, class_name: 'User',
                                  optional: true

  enum statuses: [:in_stock, :out_stock, :transfered]

  validates :iccid, presence: true,
                    uniqueness: { case_sensitive: false },
                    numericality: { only_integer: true }

  validates :phone_number, numericality: { only_integer: true },
                           length: { minimum: 9, maximum: 13 }

  before_validation :cleasing

  private

  def cleasing
    self[:iccid] = iccid.to_s.gsub(/\D+/,'')
    self[:phone_number] = phone_number.to_s.gsub(/\D+/,'')
  end

end
