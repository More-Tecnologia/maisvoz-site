module Backoffice
  module Orders
    module IndexHelper
      def order_product_path(product)
        case product.kind
        when 'course'
          course_backoffice_store_path(product.course)
        when 'deposit' || 'free'
          backoffice_products_path
        when 'publicity'
          ads_backoffice_stores_path
        when 'raffle'
          backoffice_raffles_ticket_path(product.raffle)
        end
      end

      def order_product_info_by_kind(order, product)
        case product.kind
        when 'course'
          product.course.course_lessons.size
        when 'deposit' || 'free'
          product.task_per_day
        when 'publicity'
          product.clicks
        when 'raffle'
          OrderItem.includes([:order_items]).where(product: product, order: order).size
        end
      end

      def get_product_statuses(product)
        case product.kind
        when 'raffle'
          "raffle.#{product.raffle.status}"
        else
          product.kind.to_s
        end
      end
    end
  end
end
