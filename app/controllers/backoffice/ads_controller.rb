# frozen_string_literal: true

module Backoffice
  class AdsController < BackofficeController
    before_action :ensure_ad, only: %i[edit update]
    before_action :ensure_ad_editability, only: %i[edit update]

    def index
      @ads = current_user.ads
    end

    def edit; end

    def update
      if @ad.update(valid_params)
        flash[:success] = t(:success_updated)
        redirect_to backoffice_ads_path
      else
        flash[:error] = @ad.errors.full_messages.join(', ')
        render :edit
      end
    end

    private

    def ensure_ad
      @ad = current_user.ads.find(params[:id])
    end

    def ensure_ad_editability
      return if @ad.editable?

      flash[:error] = t(:cant_edit_this_ad)
      redirect_to backoffice_ads_path
    end

    def valid_params
      params.require(:banner)
            .permit(:link, :image, :title,
                    :country_of_operation, :description)
            .merge(status: :pendent, active: true)
    end
  end
end
