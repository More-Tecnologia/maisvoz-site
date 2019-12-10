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
        return unless sponsor.empreendedor?
        create_adhesion_score(sponsor, index + 1)
        upgrade_career(sponsor)
      end
    end

    def create_adhesion_score(sponsor, height)
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
