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
      @score_type = ScoreType.find_by(id: 2)
    end

    def propagate_activation_score(user)
      sponsors = user.ascendant_sponsors
      sponsors.each_with_index do |sponsor, height|
        create_activation_score(user, height)
      end
    end

    def create_activation_score(user, height)
      Score.create!(user: user,
                    spread_user: order.user,
                    score_type: score_type,
                    cent_amount: order.activation_products_score,
                    height: height)
    end
  end
end
