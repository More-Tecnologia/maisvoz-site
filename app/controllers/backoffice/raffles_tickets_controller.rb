# frozen_string_literal: true

module Backoffice
  class RafflesTicketsController < BackofficeController
    def index
      @q = current_user.raffle_tickets
                       .includes(:raffle, :order_item)
                       .ransack(params)
      @raffle_tickets = @q.result
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(10)
    end

    def create
      @raffle = Raffle.find_by_hashid(params[:id])
      ActiveRecord::Base.transaction do
        clean_shopping_cart
        clean_courses_cart
        clean_ads_cart
        Raffles::ReserveTicketsService.call(valid_params)
      end

      redirect_to backoffice_raffles_carts_path
    rescue StandardError => error
      flash[:error] = error.message

      redirect_to backoffice_raffles_ticket_path(@raffle)
    end

    def show
      @raffle = Raffle.find_by_hashid(params[:id])
    end

    private

    def valid_params
      params.require(:raffle)
            .permit(:numbers)
            .merge(country: params[:country],
                   order: current_raffles_cart,
                   product: @raffle.product)
    end
  end
end
