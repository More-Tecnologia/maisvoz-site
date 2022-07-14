module Backoffice
  module Orders
    module IndexHelper
      def order_product_image(product)
        if product.raffle
          image_tag(product.raffle.path, class: 'product-image')
        elsif product.course
          image_tag(product.course.path, class: 'product-image')
        else
          image_tag(product.main_photo_path, class: 'product-image')
        end
      end

      def order_product_path(product)
        if product.raffle
          backoffice_raffles_ticket_path(product.raffle)
        elsif product.course
          courses_backoffice_stores_path
        elsif product.ads
          ads_backoffice_stores_path
        else
          backoffice_products_path
        end
      end
    end
  end
end
