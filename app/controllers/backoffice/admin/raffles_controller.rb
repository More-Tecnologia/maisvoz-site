# frozen_string_literal: true

module Backoffice
  module Admin
    class RafflesController < AdminController
      before_action :ensure_raffle, only: %i[edit update draw_edit draw set_draw_date]

      def index
        @q = Raffle.includes(:product)
                   .ransack(params)
        @raffles = @q.result
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(10)
      end

      def new
        @raffle = Raffle.new
      end

      def create
        build_raffle
        flash[:success] = t(:success_create)
        redirect_to backoffice_admin_raffles_path
      rescue StandardError => e
        flash[:error] = e.message
        redirect_back(fallback_location: '')
      end

      def edit; end

      def update
        update_raffle
        flash[:success] = t(:success_updated)
        redirect_to backoffice_admin_raffles_path
      rescue StandardError => e
        flash[:error] = e.message
        render :edit
      end

      def draw_edit; end

      def set_draw_date
        if @raffle.update(valid_draw_params)
          flash[:success] = t(:successfully_set_date)
          ::Raffles::TicketOwnerMailerService.call(raffle: @raffle, mailer_action: :draw_date)          
        else
          flash[:error] = @raffle.errors.full_messages.join(', ')
        end
        redirect_to backoffice_admin_raffles_path
      end

      def draw
        draw_raffle
        flash[:success] = t(:successfully_set_draw_numbers)
        ::Raffles::TicketOwnerMailerService.call(raffle: @raffle, mailer_action: :draw_result)
        redirect_to backoffice_admin_raffles_path
      rescue StandardError => e
        flash[:error] = e.message
      end

      private

      def build_raffle
        ::Raffles::CreateService.call(raffle_params: valid_raffle_params,
                                    product_params: valid_product_params)
      end

      def draw_raffle
        ::Raffles::DrawService.call(raffle: @raffle,
                                    raffle_params: { lotto_numbers: params[:raffle][:lotto_numbers].split(',') })
      end

      def ensure_raffle
        @raffle = Raffle.find_by_hashid(params[:id])
      end

      def update_raffle
        ::Raffles::UpdateService.call(raffle: @raffle,
                                    raffle_params: valid_raffle_params,
                                    product_params: valid_product_params)
      end

      def valid_draw_params
        params.require(:raffle)
              .permit(:draw_date)
              .merge(status: :awaiting_draw)
      end

      def valid_product_params
        params.require(:product)
              .permit(:short_description, :description, :price_cents, :active)
              .merge(name: valid_raffle_params[:title])
      end

      def valid_raffle_params
        params.require(:raffle)
              .permit(:title, :max_ticket_number, :thumb, images: [])
              .merge(kind: :flex)
      end
    end
  end
end
