module Bonification
  class DetachedProductScorePropagator < ApplicationService

    def call
      return unless @score_type.active
      return if detached_score <= 0
      sponsors = user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, index|
        next unless sponsor.empreendedor?
        create_detached_score(sponsor, index + 1)
      end
    end

    private

    attr_reader :order, :detached_score, :user, :score_type

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @detached_score = order.detached_products_score.to_f
      @score_type = ScoreType.detached
    end

    def create_detached_score(sponsor, height)
      cent_amount = detached_score
      sponsor.scores.create!(order: order,
                             spreader_user: order.user,
                             score_type: score_type,
                             cent_amount: cent_amount.to_i,
                             height: height) if cent_amount > 0
    end

    def detached_score
      items = order.order_items.select { |i| i.product.detached? }
      items.sum { |i| i.quantity.to_f * i.product.binary_score.to_f }.to_f
    end

  end
end
