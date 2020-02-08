module Bonification
  class BinaryFestPromotionService < ApplicationService

    def call
      return if invalid_binary_fest_promotional_date?
      return unless current_trail_available_to_promotion?
      return add_binary_fest_score_to_source_leg unless @binary_node.binary_fest
      add_fest_promotional_score_to_source_leg if @work_leg_score >= next_work_leg_score_limit
    end

    private

    INITIAL_SCORE = 5_000

    def initialize(args)
      @binary_node = args[:binary_node]
      @user = @binary_node.user
      @source_leg_score = @binary_node.source_leg_accumulated_score
      @work_leg_score = @binary_node.work_leg_accumulated_score
    end

    def invalid_binary_fest_promotional_date?
      Date.current.in_time_zone('Brasilia') > ENV['BINARY_FEST_PROMOTIONAL_DEADLINE'].to_date
    rescue Exception
      return true
    end

    def current_trail_available_to_promotion?
      @user.current_trail.product.advance?
    end

    def add_binary_fest_score_to_source_leg
      score = @user.scores.create!(spreader_user: User.find_morenwm_customer_admin,
                                   cent_amount: INITIAL_SCORE,
                                   score_type: ScoreType.binary_score,
                                   source_leg: @binary_node.source_leg,
                                   binary_fest: true)
      @binary_node.update!(binary_fest: true)
    end

    def add_fest_promotional_score_to_source_leg
      @user.scores.create!(spreader_user: User.find_morenwm_customer_admin,
                           cent_amount: next_work_leg_score_amount.to_i,
                           score_type: ScoreType.binary_score,
                           source_leg: @binary_node.source_leg,
                           binary_fest: true) if next_work_leg_score_amount.to_i > 0
    end

    def binary_fest_count
      @binary_fest_count ||= @user.scores.where(binary_fest: true).count
    end

    def next_work_leg_score_limit
      INITIAL_SCORE * (2**binary_fest_count - 1)
    end

    def next_work_leg_score_amount
      INITIAL_SCORE * (2**binary_fest_count)
    end

  end
end
