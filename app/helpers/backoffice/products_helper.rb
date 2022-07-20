module Backoffice
  module ProductsHelper
    def main_photo_hint
      "#{Product::PHOTO_WIDTH} x #{Product::PHOTO_HEIGHT}"
    end

    def photos_hint
      "#{Product::PHOTO_WIDTH} x #{Product::PHOTO_HEIGHT} (#{t('backoffice.admin.media_files.form.maximum_number_of_photos', maximum_number: Product::MAXIMUM_NUMBER_OF_PHOTOS)})"
    end

    def product_descriptions(product)
      positions = (1..Product::MAXIMUM_NUMBER_OF_PRODUCT_DESCRIPTIONS).to_a
      positions.map do |i|
        product.product_descriptions.detect { |d| d.position == i } ||
        product.product_descriptions.build(position: i)
      end
    end

    def description_photo_hint position
      return "#{ProductDescription::MAIN_PHOTO_WIDTH} x #{ProductDescription::MAIN_PHOTO_HEIGHT}" if position == 1

      "#{ProductDescription::PHOTO_WIDTH} x #{ProductDescription::PHOTO_HEIGHT}"
    end

    def most_sold_products limit
      sql = "SELECT product_id, SUM(quantity) AS total_quantity "
      sql += "FROM order_items GROUP BY product_id ORDER BY SUM(quantity) DESC "
      sql += "LIMIT #{limit};"

      records_array = ActiveRecord::Base.connection.execute(sql)

      Product.where(id: records_array.map{ |product| product["product_id"] })
    end

    def is_free_product_available(user)
      if(user)
        !user.orders.includes(:products).where(products: {kind: :free}).any?
      else
        true
      end
    end
  end
end
