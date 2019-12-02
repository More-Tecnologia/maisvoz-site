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
      @score_type = ScoreType.find_by(id: 1)
    end

    def propagate_adhesion_score(user)
      sponsors = order.user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, height|
        create_adhesion_score(sponsor, height)
      end
    end

    def create_adhesion_score(sponsor, height)
      Score.create!(user: sponsor,
                    spreader_user: order.user,
                    score_type: score_type,
                    cent_amount: adhesion_product.binary_score,
                    height: height)
    end
  end
end
