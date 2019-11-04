module Bonification
  module Propagator
    class BinaryScoreService < ApplicationService

      def call
        return if user_binary_node.blank? || total_score <= 0
        propagate_binary_score
      end

      private

      attr_reader :order, :binary_score

      def initialize(args)
        @order = args[:order]
        @binary_score = ScoreType.binary_score
      end

      def propagate_binary_score
        ascendant_path = user_binary_node.path.includes_associations.reverse
        child_and_parent = ascendant_path.each_cons(2).to_a
        child_and_parent.each_with_index do |(child, parent), index|
          create_score(child, parent, index + 1)
        end
      end

      def create_score(child, parent, generation)
        user = parent.user
        score = create_binary_score(user, child, parent, generation)
        check_should_chargeback(score, child, parent)
      end

      def create_binary_score(user, child_node, parent_node, generation)
        source_leg = parent_node.find_leg(child_node)
        user.scores.create!(source_leg: source_leg,
                            order: order,
                            spreader_user: order.user,
                            cent_amount: total_score,
                            height: generation,
                            score_type: binary_score)
      end

      def check_should_chargeback(score, child_node, parent_node)
        user = score.user
        return chargeback_by_binary_unqualification!(score) if user.binary_unqualified?

        score_leg = parent_node.find_leg(child_node)
        score_leg_is_shortter_leg = parent_node.is_shortter_leg?(score_leg)
        excess_score = parent_node.calculate_unqualified_score(total_score)
        chargeback_by_inactivity!(score, excess_score) if user.inactive? && score_leg_is_shortter_leg && excess_score > 0
      end

      def chargeback_by_binary_unqualification!(score)
        score.chargeback!(ScoreType.binary_unqualified_chargeback)
      end

      def chargeback_by_inactivity!(score, amount)
        score_type = ScoreType.inactivity_chargeback
        score.chargeback!(score_type, amount)
      end

      def user_binary_node
        @user_binary_node ||= order.user.binary_node
      end

      def total_score
        @total_score ||= order.total_score
      end

    end
  end
end
