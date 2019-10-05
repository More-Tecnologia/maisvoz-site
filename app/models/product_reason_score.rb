class ProductReasonScore < ApplicationRecord
  belongs_to :product
  belongs_to :financial_reason
end
