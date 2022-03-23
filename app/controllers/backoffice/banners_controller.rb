module Backoffice
  class BannersController < BackofficeController
    before_action :ensure_creation, only: :create
    before_action :ensured_banner, only: %i[update destroy]

    def index
      @banners_clicks = current_user.banner_clicks
                                    .order(created_at: :desc)
                                    .page(params[:page])
                                    .per(10)
    end

    def new
      @banner = Banner.new
    end

    def create
      flash[:success] = I18n.t(:success_create_banner)
      redirect_to backoffice_banners_path
    end

    def update
      if @banner.update(ensured_params)
        flash[:success] = I18n.t(:success_update_banner)
        redirect_to backoffice_banners_path
      else
        flash[:error] = @banner.errors.full_messages.join(', ')
        render :edit
      end
    end

    def destroy
      if @banner.update(active: false)
        flash[:success] = I18n.t(:success_inactivate_banner)
      else
        flash[:error] = @banner.errors.full_messages.join(', ')
      end
      redirect_to backoffice_banners_path
    end

    private

    def ensure_creation
      # this step is necessary because of attachinary gem bug -
      # https://github.com/assembler/attachinary/issues/130
      # Remove this gem in favor of active storage
      new_params = ensured_params
      file = new_params.delete(:image)

      @banner = BannerStore.ads.banners.build(new_params)
      @banner.save
      return if @banner.persisted? && @banner.update(image: file)

      flash[:error] = @banner.errors.full_messages.join(', ')
      @banner.destroy
      render :new
    end

    def ensured_banner
      @banner = Banner.find(params[:id])
    end

    def ensured_params
      params.require(:banner)
            .permit(:link, :image_path, :image, :title,
                    :country_of_operation, :description)
            .merge(user: current_user, premium: true)
    end
  end
end
