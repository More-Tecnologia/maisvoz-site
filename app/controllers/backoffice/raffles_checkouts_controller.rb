# frozen_string_literal: true

module Backoffice
  class RafflesCheckoutsController < BackofficeController
    before_action :format_document_id
    before_action :ensure_name_and_id
    before_action :ensure_payment_method
    before_action :ensure_minimun_expend_to_use_promotional_balance

    def create
      if valid_params[:payment_method] == 'balance' && current_user.orders.completed.includes(order_items: :product).where(order_items: { products: { kind: :deposit }}).any?
        @order = current_raffles_cart
        Payment::BalanceService.call(order: @order)
        current_raffles_cart
        redirect_to backoffice_order_path(@order)
      elsif valid_params[:payment_method] == 'promotional_balance'
        @order = current_raffles_cart
        Payment::PromotionalBalanceService.call(order: @order)
        current_raffles_cart
        redirect_to backoffice_order_path(@order)
      elsif valid_params[:payment_method] == 'pix'
        @payment_transaction = Payment::Pagstar::PixCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 1.hour, valid_params[:order].id)
        RemoveReservedRaffleTicketsWorker.perform_at(Time.now + 1.hour, valid_params[:order].id)
        current_raffles_cart
        render 'backoffice/payment_transactions/show'
      elsif valid_params[:payment_method] == 'btc'
        @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 2.hour, valid_params[:order].id)
        RemoveReservedRaffleTicketsWorker.perform_at(Time.now + 2.hour, valid_params[:order].id)
        current_raffles_cart
        render 'backoffice/payment_transactions/show'
      end
    rescue StandardError => error
      flash[:error] = error.message
      render 'backoffice/raffles_carts/show'
    end

    private

    def format_document_id
      @document_id = params[:document_id]&.gsub(/\D+/, '')
    end

    def ensure_minimun_expend_to_use_promotional_balance
      return unless params[:payment_method] == 'promotional_balance'
      return if current_user.orders.where(payment_type: [:btc, :admin, :pix]).completed.sum(:total_cents) >= 500

      flash[:error] =I18n.t(:minimum_expend_to_use_promotional_balance)
      redirect_to backoffice_raffles_carts_path
    end

    def ensure_name_and_id
      return if current_user.document_cpf.present? && current_user.name.present?

      if @document_id.blank? || params[:user_name].blank?
        flash[:error] =I18n.t(:id_or_name_blank)
        redirect_to backoffice_raffles_carts_path
      else
        current_user.update(document_cpf: @document_id, name: params[:user_name])
      end
    end

    def ensure_payment_method
      return if params[:payment_method].present?

      flash[:error] =I18n.t(:payment_method_blank)
      redirect_to backoffice_raffles_carts_path
    end

    def valid_params
      params.permit(:payment_method)
            .merge(order: current_raffles_cart)
    end
  end
end
