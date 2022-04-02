# frozen_string_literal: true

module Backoffice
  class RafflesTicketsController < BackofficeController
    def index; end

    def create
      redirect_to backoffice_raffles_carts_path
    end

    def show
      @raffle = Raffle.find_by_hashid(params[:id])
    end

    private

    def ensure_creation
      # this step is necessary because of attachinary gem bug -
      # https://github.com/assembler/attachinary/issues/130
      # Remove this gem in favor of active storage
      @raffle = Raffle.find_by_hashid(params[:id])
      @product = @raffle.product
      @tickets = @raffle.raffle_tickets.where(number: prams[:number])
      ActiveRecord::Base.transaction do
        clean_shopping_cart
        clean_courses_cart
        clean_ads_cart
        command = Shopping::AddToCart.call(current_ads_cart, @product.id, params[:country])
        raise StandardError.new(command.errors) unless command.success?
        @banner.order_item = current_ads_cart.order_items.reload.order(:created_at).last
        if @banner.valid?(:ads)
          unless @banner.save && @banner.update(image: file)
            @banner.order_item.destroy
            Shopping::UpdateCartTotals.call(current_ads_cart, params[:country])
          end
        end
      end
      return if @banner.persisted?

      flash[:error] = @banner.errors.full_messages.join(', ')
      @banner.destroy
      render :new
    rescue StandardError => error
      @banner = Banner.new(ensured_params)
      flash[:error] = error.message
      render :new
    end
  end
end
