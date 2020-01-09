module Bonification
  class ActivationProductScorePropagator < ApplicationService

    def call
      return unless activation_product
      propagate_activation_score(order.user)
    end

    private

    attr_reader :order, :activation_product, :score_type

    def initialize(args)
      @order = args[:order]
      @activation_product = order.activation_product
      @score_type = ScoreType.activation
    end

    def propagate_activation_score(user)
      sponsors = order.user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, index|
        next unless sponsor.empreendedor?
        create_activation_score(sponsor, index + 1)
        upgrade_career(sponsor)
      end
    end

    def create_activation_score(sponsor, height)
      cent_amount = activation_score
      sponsor.scores.create!(order: order,
                             spreader_user: order.user,
                             score_type: score_type,
                             cent_amount: cent_amount.to_i,
                             height: height) if cent_amount > 0
    end

    def upgrade_career(sponsor)
      UpgraderCareerService.call(user: sponsor)
    end

    def activation_score
      items = order.order_items.select { |i| i.product.activation? }
      items.sum { |i| i.quantity.to_f * i.product.binary_score.to_f }.to_f
    end

  end
end
