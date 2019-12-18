class SimCard < ApplicationRecord

  include Hashid::Rails

  has_paper_trail

  belongs_to :user, optional: true
  belongs_to :order_item
  belongs_to :support_point_user, class_name: 'User',
                                  optional: true

  enum status: [:in_stock, :out_stock, :transfered]

  validates :iccid, presence: true,
                    uniqueness: { case_sensitive: false },
                    numericality: { only_integer: true }

  validates :phone_number, numericality: { only_integer: true },
                           length: { minimum: 9, maximum: 13 },
                           allow_blank: true

  before_validation :cleasing

  scope :by_support_point, ->(user) { where(support_point_user: user) }
  scope :available, -> { where(user: nil) }
  scope :by_iccids, ->(iccids) { where(iccid: iccids) }

  private

  def cleasing
    self[:iccid] = iccid.to_s.gsub(/\D+/,'')
    self[:phone_number] = phone_number.to_s.gsub(/\D+/,'')
  end

end
