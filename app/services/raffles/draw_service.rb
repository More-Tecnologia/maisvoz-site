# frozen_string_literal: true

module Raffles
  class DrawService < ApplicationService
    def initialize(params)
      @raffle = params[:raffle]
      @raffle_params = params[:raffle_params]
      @lotto_numbers_combination = lotto_numbers_combination
      p @lotto_numbers_combination
    end

    private

    def lotto_numbers_combination
      @raffle_params[:lotto_numbers].reduce('') do |combination, number|
        combination + number[1]
      end[0...@raffle.max_ticket_number.to_s.length - 1].to_i
    end

    def call
      ActiveRecord::Base.transaction do
        update_raffle
      end
    end

    def update_raffle
      @raffle.update(@raffle_params.merge(lotto_numbers_combination: @lotto_numbers_combination,
                                          status: :finished,
                                          winner: winner,
                                          winning_ticket: winning_ticket))
    end

    def winner
      winning_ticket.user
    end

    def winning_ticket
      @winning_ticket ||= @raffle.raffle_tickets
                                 .where(number: @lotto_numbers_combination)
                                 .last
    end
  end
end
