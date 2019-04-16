# == Schema Information
#
# Table name: order_of_services
#
#  id                  :bigint(8)        not null, primary key
#  user_id             :bigint(8)
#  created_by_id       :bigint(8)
#  os_number           :string
#  gross_sales_cents   :bigint(8)        default(0), not null
#  net_sales_cents     :bigint(8)        default(0), not null
#  gross_service_cents :bigint(8)        default(0), not null
#  net_service_cents   :bigint(8)        default(0), not null
#  profit_cents        :bigint(8)        default(0), not null
#  total_score         :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_order_of_services_on_created_by_id  (created_by_id)
#  index_order_of_services_on_os_number      (os_number) UNIQUE
#  index_order_of_services_on_user_id        (user_id)
#

class OrderOfService < ApplicationRecord

  monetize :gross_sales_cents, :net_sales_cents, :gross_service_cents, :net_service_cents,
  :profit_cents

  belongs_to :user
  belongs_to :created_by, class_name: 'User'
end
