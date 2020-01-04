class FinancialReasonType < ApplicationRecord
  has_many :financial_reasons

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   numericality: { only_integer: true }

  def self.bonus
      @@bonus ||= find_by(code: '200')
  end
end
