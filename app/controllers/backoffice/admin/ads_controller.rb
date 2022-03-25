# frozen_string_literal: true

module Backoffice
  module Admin
    class AdsController < AdminController
      before_action :ensured_ad, only: %i[approve reprove]

      def index
        @q = BannerStore.ads_store
                        .ransack(params)

        @ads = @q.result
                 .order(:id)
                 .page(params[:page])
                 .per(10)
      end

      def approve
        if @ad.update(status: :approved, active: true)
          flash[:success] = I18n.t(:success_update_banner)
          redirect_to backoffice_admin_banners_path
        else
          flash[:error] = @ad.errors.full_messages.join(', ')
          render :edit
        end
      end

      def reprove
        if @ad.update(active: false)
          flash[:success] = I18n.t(:success_inactivate_banner)
        else
          flash[:error] = @ad.errors.full_messages.join(', ')
        end
        redirect_to backoffice_admin_banners_path
      end

      private

      def ensured_ad
        @ad = Banner.find(params[:id])
      end

      def ensured_params
        params.require(:banner).permit(:notem)
      end
    end
  end
end
