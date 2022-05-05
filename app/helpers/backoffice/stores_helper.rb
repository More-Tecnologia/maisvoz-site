module Backoffice
  module StoresHelper
    BANNER_ATTRIBUTE_LIST_BY_KIND = {
      deposit: { description: :task_per_day, image: :main_photo_path, price: :price, title: :name },
      course: { description: :course_short_description, image: :course_path, price: :price, title: :name },
      publicity: { description: :clicks, image: :main_photo_path, price: :price, title: :name },
      raffle: { description: :description, image: :raffle_path, price: :price, title: :name }
    }

    def banner_attribute_by_noddle(banner_item, noddle_sym)
      BANNER_ATTRIBUTE_LIST_BY_KIND[banner_item.kind.to_sym][noddle_sym]
    end

    def banner_noddle(banner_item, noddle_sym)
      banner_item.send(banner_attribute_by_noddle(banner_item, noddle_sym))
    end

    def banner_items_factory(banner_item)
      banner_items = OpenStruct.new(price_text: t(:price), image: banner_noddle(banner_item, :image),
                                    price: format_curency(banner_noddle(banner_item, :price)), title: banner_noddle(banner_item, :title))
      banner_noddle(banner_item, :price) > 0 || banner_items[:price] = t(:free)
      case banner_item.kind
      when 'deposit'
        banner_items[:badge_image] = 'stores/banner-badge.svg'
        banner_items[:badge_text] = t(:package)
        banner_items[:description] = banner_noddle(banner_item, :description).to_s + ' ' + t(:tasks_per_day)
        banner_items[:price_right_text] = t(:earnings_by_campaign)
        banner_items[:price_right] = format_curency(banner_item.earnings_per_campaign)
      when 'course'
        banner_items[:badge_image] = 'stores/banner-badge.svg'
        banner_items[:badge_text] = banner_item.course.categorizations.sample.title
        banner_items[:description] = banner_noddle(banner_item, :description)
      when 'publicity'
        banner_items[:badge_image] = 'stores/banner-badge.svg'
        banner_items[:badge_text] = t(:top_deal)
        banner_items[:description] =
          t(:this_pack_contains) + ' ' + banner_noddle(banner_item, :description).to_s + ' ' + t(:on_the_ad)
      when 'raffle'
        banner_items[:badge_image] = 'stores/banner-badge.svg'
        banner_items[:badge_text] = t(:last_numbers)
        banner_items[:description] = banner_noddle(banner_item, :description)
      end
      banner_items
    end
  end
end
