# frozen_string_literal: true

module Dashboards
  module Users
    class StoresPresenter
      BANNER_ATTRIBUTE_LIST_BY_KIND = {
        deposit: { description: :task_per_day, image: :main_photo_path, price: :price, title: :name },
        course: { description: :course_short_description, image: :course_path, price: :price, title: :name },
        publicity: { description: :clicks, image: :main_photo_path, price: :price, title: :name },
        raffle: { description: :description, image: :raffle_path, price: :price, title: :name }
      }.freeze

      attr_reader :price, :price_text, :image, :title, :badge_image, :badge_text, :description, :price_right,
                  :price_right_text

      def initialize(banner_item)
        @badge_image = get_badge_image(banner_item)
        @badge_text = get_badge_text(banner_item)
        @description = banner_description(banner_item)
        @image = banner_noddle(banner_item, :image)
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

      def banner_noddle(banner_item, noddle_sym)
        banner_item.send(banner_attribute_by_noddle(banner_item, noddle_sym))
      end

      def banner_description(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:description]
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

      def banner_custom_attributes_by_kind(banner_item)
        send("#{banner_item.kind}_banner_attributes", banner_item)
      end

      def course_banner_attributes(banner_item)
        {
          description: banner_noddle(banner_item, :description),
          image: 'stores/banner-badge.svg',
          price_right: '',
          price_right_text: '',
          text: banner_item.course.categorizations.sample.title
        }
      end

      def deposit_banner_attributes(banner_item)
        {
          description: "#{banner_noddle(banner_item, :description)} #{I18n.t(:tasks_per_day)}",
          image: 'stores/banner-badge.svg',
          price_right: h.format_currency(banner_item.earnings_per_campaign),
          price_right_text: I18n.t(:earnings_by_campaign),
          text: I18n.t(:package)
        }
      end

      def format_banner_price(price)
        if price.positive?
          h.format_currency(price)
        else
          I18n.t(:free)
        end
      end

      def get_badge_image(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:image]
      end

      def get_badge_text(banner_item)
        banner_custom_attributes_by_kind(banner_item)[:text]
      end

      def h
        ApplicationController.helpers
      end

      def publicity_banner_attributes(banner_item)
        {
          description: "#{I18n.t(:this_pack_contains)} #{banner_noddle(banner_item,
                                                                       :description)} #{I18n.t(:on_the_ad)}",
          image: 'stores/banner-badge.svg',
          price_right: '',
          price_right_text: '',
          text: I18n.t(:top_deal)
        }
      end

      def raffle_banner_attributes(banner_item)
        {
          description: banner_noddle(banner_item, :description),
          image: 'stores/banner-badge.svg',
          price_right: '',
          price_right_text: '',
          text: I18n.t(:last_numbers)
        }
      end
    end
  end
end
