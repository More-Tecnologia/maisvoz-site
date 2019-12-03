module Bonification
  class DetachedProductScorePropagator < ApplicationService

    def call
      return if detached_score <= 0
      sponsors = user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, index|
        create_detached_score(sponsor, index + 1) if sponsor.empreendedor?
      end
    end

    private

    attr_reader :order, :detached_score, :user

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @detached_score = order.detached_products_score
      @score_type = ScoreType.detached
    end

    def create_detached_score(sponsor, height)
      score = Score.create!(user: sponsor,
                            order: order,
                            spreader_user: order.user,
                            score_type: score_type,
                            cent_amount: order.activation_products_score,
                            height: height)
    end
  end
end
