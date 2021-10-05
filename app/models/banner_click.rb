class BannerClick < ApplicationRecord
  QUANTITY_MINIMUM_VIEW_PER_DAY = 5

  belongs_to :user
  belongs_to :banner
  belongs_to :financial_transaction

  scope :today,
    -> { where(created_at: (Date.current.beginning_of_day..Date.current.end_of_day)) }
end
