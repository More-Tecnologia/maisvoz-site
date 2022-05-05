module Backoffice
  module StoresHelper
    BANNER_ATTRIBUTE_LIST_BY_KIND = {
      deposit: { description: :task_per_day, image: :main_photo_path, price: :price, title: :name },
      course: { description: :course_short_description, image: :course_path, price: :price, title: :name },
      publicity: { description: :clicks, image: :main_photo_path, price: :price, title: :name },
      raffle: { description: :description, image: :raffle_path, price: :price, title: :name }
    }
        
    def banner_attribute_by_noddle(banner_item, noddle)
      BANNER_ATTRIBUTE_LIST_BY_KIND[banner_item.kind.to_sym][noddle]
    end

    def banner_noddle(banner_item, noddle)
      banner_item.send(banner_attribute_by_noddle(banner_item, noddle))
    end
  end
end