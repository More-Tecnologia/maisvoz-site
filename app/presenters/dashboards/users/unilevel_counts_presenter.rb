# frozen_string_literal: true

module Dashboards
  module Users
    class UnilevelCountsPresenter

      def initialize(user)
        @user = user
        @children = @user.unilevel_node.children
      end

      def build
        {
          data: { unilevel_counts: unilevel_counts },
          labels: labels
        }
      end

      private

      def unilevel_counts
        {
          unilevel_affiliates_count: unilevel_affiliates_count,
          unilevel_affiliates_actives_count: unilevel_affiliates_actives_count,
          unilevel_affiliates_inactives_count: unilevel_affiliates_inactives_count
        }
      end

      def labels
        {
          unilevel_affiliates_count: I18n.t(:unilevel_affiliates_count),
          unilevel_affiliates_actives_count: I18n.t(:unilevel_affiliates_actives_count),
          unilevel_affiliates_inactives_count: I18n.t(:unilevel_affiliates_inactives_count)
        }
      end

      def unilevel_affiliates_count
        @children.count
      end

      def unilevel_affiliates_actives_count
        @children.includes(:user).where(user: User.active).count
      end

      def unilevel_affiliates_inactives_count
        @children.includes(:user).where(user: User.inactive).count
      end

    end
  end
end
