# frozen_string_literal: true

module Dashboards
  module Users
    class BinaryCountsPresenter

      def initialize(user)
        @user = user
      end

      def build
        {
          data: { binary_count: binary_count },
          labels: labels
        }
      end

      private

      def binary_affiliates_count
        @user.binary_node.descendants.count
      end

      def binary_affiliates_left_count
        return 0 unless @user.binary_node.left_child.present?

        @user.binary_node.left_child.descendants.count + 1
      end

      def binary_affiliates_right_count
        return 0 unless @user.binary_node.right_child.present?

        @user.binary_node.right_child.descendants.count + 1
      end

      def binary_count
        {
          binary_affiliates_count: binary_affiliates_count,
          binary_affiliates_left_count: binary_affiliates_left_count,
          binary_affiliates_right_count: binary_affiliates_right_count
        }
      end

      def labels
        {
          binary_affiliates_count: I18n.t(:binary_affiliates_count),
          binary_affiliates_left_count: I18n.t(:binary_affiliates_left_count),
          binary_affiliates_right_count: I18n.t(:binary_affiliates_right_count)
        }
      end

    end
  end
end
