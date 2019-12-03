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
        return unless sponsor.empreendedor?
        create_activation_score(sponsor, index + 1)
        upgrade_career(sponsor)
      end
    end

    def create_activation_score(sponsor, height)
      score = Score.create!(user: sponsor,
                            order: order,
                            spreader_user: order.user,
                            score_type: score_type,
                            cent_amount: order.activation_products_score,
                            height: height)
    end

    def upgrade_career(sponsor)
      UpgraderCareerService.call(user: sponsor)
    end

  end
end
