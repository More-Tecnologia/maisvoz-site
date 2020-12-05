class BannerClick < ApplicationRecord
  QUANTITY_MINIMUM_VIEW_PER_DAY = 5

  belongs_to :user
  belongs_to :banner

  scope :today,
    -> { where(created_at: (Date.today.beginning_of_day..Date.today.end_of_day)) }
end
