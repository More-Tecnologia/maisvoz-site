# frozen_string_literal: true

module Raffles
  class TicketOwnerMailerService < ApplicationService
    def initialize(params)
      @raffle = params[:raffle]
      @mailer_action = params[:mailer_action]
    end

    private

    def call
      draw_mailer
    end
    
    def draw_mailer
      @raffle.raffle_tickets.map(&:user).uniq.each do |user|
        RaffleMailer.send(@mailer_action, user, @raffle).deliver_later
      end
    end
  end
end