# frozen_string_literal: true

module Backoffice
  module Admin
    class AdsController < AdminController
      before_action :ensured_ad, only: %i[approve reprove]

      def index
        params.merge!(status_eq: 0) unless params[:status_eq].present?
        @q = BannerStore.ads_store
                        .banners
                        .includes(:user, :product, :order)
                        .ransack(params.merge(user_username_cont: (params[:username_cont].presence || ['']).first)
                                       .except(:username_cont))

        @ads = @q.result
                 .order(updated_at: :desc)
                 .page(params[:page])
                 .per(10)
      end

      def approve
        if active_banner?
          flash[:success] = I18n.t(:successfully_approve_ad)
        else
          flash[:error] = @ad.errors.full_messages.join(', ')
        end

        redirect_to backoffice_admin_ads_path
      end

      def reprove
        if @ad.update(active: false)
          flash[:success] = I18n.t(:successfully_reprove_ad)
        else
          flash[:error] = @ad.errors.full_messages.join(', ')
        end
        redirect_to backoffice_admin_ads_path
      end

      private

      def active_ads_process_bonus
        AdsDirectIndirectWorker.perform_async(@ad.id)
      end

      def active_banner?
        if @ad.billed?
          @ad.update(status: :approved, active: true)
        else
          active_ads_process_bonus
        end
      end

      def ensured_ad
        @ad = Banner.find(params[:id])
      end
    end
  end
end
