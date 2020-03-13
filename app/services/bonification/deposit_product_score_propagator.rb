module Bonification
  class DepositProductScorePropagator < ApplicationService

    def call
      return unless @deposit_score.positive? && @score_type.active
      propagate_deposit_score(order.user)
    end

    private

    attr_reader :order, :deposit_product, :score_type

    def initialize(args)
      @order = args[:order]
      @deposit_score = calculate_deposit_score
      @score_type = ScoreType.deposit
    end

    def propagate_deposit_score(user)
      sponsors = order.user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, index|
        next unless sponsor.empreendedor?
        create_deposit_score(sponsor, index + 1)
      end
    end

    def create_deposit_score(sponsor, height)
      sponsor.scores.create!(order: order,
                             spreader_user: order.user,
                             score_type: score_type,
                             cent_amount: @deposit_score,
                             height: height)
    end

    def calculate_deposit_score
      items = order.order_items.select { |i| i.product.deposit? }
      items.sum { |i| i.quantity.to_f * i.product.binary_score.to_f }.to_i
    end

  end
end
