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
          create_binary_score(child, parent, index + 1) if parent.user.empreendedor?
        end
      end

      def create_binary_score(child_node, parent_node, generation)
        user = parent_node.user
        source_leg = parent_node.find_leg(child_node)
        user.scores.create!(source_leg: source_leg,
                            order: order,
                            spreader_user: order.user,
                            cent_amount: total_score,
                            height: generation,
                            score_type: binary_score)
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
