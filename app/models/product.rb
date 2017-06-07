# == Schema Information
#
# Table name: products
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  short_description :string
#  sku               :string(10)
#  quantity          :integer
#  low_stock_alert   :integer
#  weight            :decimal(10, 2)
#  length            :integer
#  width             :integer
#  height            :integer
#  price_cents       :integer
#  binary_score      :integer
#  advance_score     :integer
#  active            :boolean
#  virtual           :boolean
#  paid_by           :integer
#  category_id       :integer
#  career_id         :integer
#  bonus_1           :integer
#  bonus_2           :integer
#  bonus_3           :integer
#  bonus_4           :integer
#  bonus_5           :integer
#  bonus_6           :integer
#  bonus_7           :integer
#  bonus_8           :integer
#  bonus_9           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_products_on_career_id    (career_id)
#  index_products_on_category_id  (category_id)
#

class Product < ApplicationRecord

  belongs_to :category
  belongs_to :career

  monetize :price_cents

end
