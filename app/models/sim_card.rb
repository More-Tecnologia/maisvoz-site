class SimCard < ApplicationRecord

  include Hashid::Rails

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
  before_validation :assign_report_dates
  before_validation :assign_status

  scope :by_support_point, ->(user) { where(support_point_user: user) }
  scope :available, -> { where(user: nil) }
  scope :by_iccids, ->(iccids) { where(iccid: iccids) }
  scope :by_user, ->(user) { where(user: user) }

  private

  def cleasing
    self[:iccid] = iccid.to_s.gsub(/\D+/,'')
    self[:phone_number] = phone_number.to_s.gsub(/\D+/,'')
  end

  def assign_report_dates
    self[:support_point_stock_in_at] = Time.current if support_point_user && !support_point_stock_in_at
    self[:support_point_stock_out_at] = Time.current if user && support_point_user && !support_point_stock_out_at
    self[:user_stock_in_at] = Time.current if user && !user_stock_in_at
    self[:user_stock_out_at] = Time.current if actived_at && !user_stock_out_at
    self[:stock_out_at] = Time.current if phone_number.present? && stock_out_at.nil?
  end

  def assign_status
    self[:status] = SimCard.statuses[detect_status]
  end

  private

  def detect_status
    return :transfered if user && support_point_user && !phone_number
    phone_number.present? ? :out_stock : :in_stock
  end

end
