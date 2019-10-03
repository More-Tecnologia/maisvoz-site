module Bonification
  class DetachedProductScorePropagator < ApplicationService

    def call
      return if detached_score <= 0
      sponsors = user.ascendant_sponsors
      sponsors.each_with_index do |sponsor, height|
        create_detached_score(sponsor, height)
      end
    end

    private

    attr_reader :order, :detached_score, :user

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @detached_score = order.detached_products_score
      @score_type = ScoreType.find_by(id: 3)
    end

    def create_detached_score(sponsor, height)
      Score.create!(user: sponsor,
                    spread_user: user,
                    score_type: score_type,
                    cent_amount: detached_score,
                    height: height)
    end
  end
end
