# frozen_string_literal: true

module Backoffice
  class RafflesController < BackofficeController
    skip_before_action :authenticate_user!, only: :winners

    def index; end

    def winners
      @raffles = Raffle.finished
                       .order(draw_date: :desc)
                       .page(params[:page])
                       .per(10)
    end

    def show; end
  end
end
