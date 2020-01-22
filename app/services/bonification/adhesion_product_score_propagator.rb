module Bonification
  class AdhesionProductScorePropagator < ApplicationService

    def call
      return unless adhesion_product
      propagate_adhesion_score(order.user)
    end

    private

    attr_reader :order, :adhesion_product, :score_type

    def initialize(args)
      @order = args[:order]
      @adhesion_product = order.adhesion_product
      @score_type = ScoreType.adhesion
    end

    def propagate_adhesion_score(user)
      sponsors = order.user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, index|
        next unless sponsor.empreendedor?
        create_adhesion_score(sponsor, index + 1)
      end
    end

    def create_adhesion_score(sponsor, height)
      cent_amount = adhesion_score
      sponsor.scores.create!(order: order,
                             spreader_user: order.user,
                             score_type: score_type,
                             cent_amount: cent_amount.to_i,
                             height: height) if cent_amount > 0
    end

    def adhesion_score
      items = order.order_items.select { |i| i.product.adhesion? }
      items.sum { |i| i.quantity.to_f * i.product.binary_score.to_f }.to_f
    end

  end
end
