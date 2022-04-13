# frozen_string_literal: true

module Backoffice
  class RafflesController < BackofficeController
    def index; end

    def agreement; end

    def winners
      @q = Raffle.all
      @raffles = @q.order(created_at: :desc)
                   .page(params[:page])
                   .per(10)
    end

    def show; end
  end
end
