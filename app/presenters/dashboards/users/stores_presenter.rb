# frozen_string_literal: true

module Dashboards
  module Users
    class StoresPresenter
      include Rails.application.routes.url_helpers

      BANNER_ATTRIBUTE_LIST_BY_KIND = {
        course: { description: :course_short_description, image: :course_path, price: :price, title: :name, link: :link, link_method: :link_method },
        deposit: { description: :task_per_day, image: :main_photo_path, price: :price, title: :name, link: :link, link_method: :link_method },        
        publicity: { description: :clicks, image: :main_photo_path, price: :price, title: :name, link: :link, link_method: :link_method },
        raffle: { description: :description, image: :raffle_path, price: :price, title: :name, link: :link, link_method: :link_method }
      }.freeze

      attr_reader :price, :price_text, :image, :title, :badge_image, :badge_text, :description, :price_right,
                  :price_right_text, :link, :link_method

      def initialize(banner_item)
        @badge_image = get_badge_image(banner_item)
        @badge_text = get_badge_text(banner_item)
        @description = banner_description(banner_item)
        @image = banner_noddle(banner_item, :image)
        @link = get_banner_link(banner_item)
        @link_method = get_banner_link_method(banner_item)
        @price = banner_price(banner_item)
        @price_right = banner_price_right(banner_item)
        @price_right_text = banner_price_right_text(banner_item)
        @price_text = I18n.t(:price)
        @title = banner_noddle(banner_item, :title)
      end

      private

      def banner_attribute_by_noddle(banner_item, noddle_sym)
        BANNER_ATTRIBUTE_LIST_BY_KIND[banner_item.kind.to_sym][noddle_sym]
      end

      def banner_custom_attributes_by_kind(banner_item)
        send("#{banner_item.kind}_banner_attributes", banner_item)
      end

      def banner_description(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:description]
      end

      def banner_noddle(banner_item, noddle_sym)
        banner_item.send(banner_attribute_by_noddle(banner_item, noddle_sym))
      end

      def banner_price(banner_item)
        format_banner_price(banner_noddle(banner_item, :price))
      end

      def banner_price_right(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:price_right]
      end

      def banner_price_right_text(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:price_right_text]
      end

      def course_banner_attributes(banner_item)
        {
          description: banner_noddle(banner_item, :description),
          image: 'stores/banner-badge.svg',
          price_right: '',
          price_right_text: '',
          text: banner_item.course.categorizations.sample.title,
          link: course_backoffice_store_path(banner_item.course),
          link_method: :get
        }
      end

      def deposit_banner_attributes(banner_item)
        {
          description: "#{banner_noddle(banner_item, :description)} #{I18n.t(:tasks_per_day)}",
          image: 'stores/banner-badge.svg',
          price_right: helpers.format_currency(banner_item.earnings_per_campaign),
          price_right_text: I18n.t(:earnings_by_campaign),
          text: I18n.t(:package),
          link: backoffice_order_items_path(product: {id: banner_item.hashid}),
          link_method: :post
        }
      end

      def format_banner_price(price)
        price.positive? ? helpers.format_currency(price) : I18n.t(:free)
      end

      def get_badge_image(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:image]
      end
        
      def get_badge_text(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:text]
      end

      def get_banner_link(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:link]
      end

      def get_banner_link_method(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:link_method]
      end

      def helpers
        ApplicationController.helpers
      end

      def publicity_banner_attributes(banner_item)
        {
          description: "#{I18n.t(:this_pack_contains)} #{banner_noddle(banner_item,
                                                                       :description)} #{I18n.t(:on_the_ad)}",
          image: 'stores/banner-badge.svg',
          price_right: '',
          price_right_text: '',
          text: I18n.t(:top_deal),
          link: new_backoffice_banner_path(product_id: banner_item.id),
          link_method: :get
        }
      end

      def raffle_banner_attributes(banner_item)
        {
          description: banner_noddle(banner_item, :description),
          image: 'stores/banner-badge.svg',
          price_right: '',
          price_right_text: '',
          text: I18n.t(:last_numbers),
          link: backoffice_raffles_ticket_path(banner_item.raffle),
          link_method: :get
        }
      end
    end
  end
end
