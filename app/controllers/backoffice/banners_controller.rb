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
      @product = Product.find(params[:product_id])
      @banner = @product.ads.build
    end

    def create
      redirect_to backoffice_ads_carts_path
    end

    private

    def ensure_creation
      # this step is necessary because of attachinary gem bug -
      # https://github.com/assembler/attachinary/issues/130
      # Remove this gem in favor of active storage
      @product = Product.find(params[:product_id])
      new_params = ensured_params
      file = new_params.delete(:image)

      @banner = @product.ads.build(new_params)
      ActiveRecord::Base.transaction do
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
      flash[:error] = error.message
      render :new
    end

    def ensured_params
      params.require(:banner)
            .permit(:link, :image, :title,
                    :country_of_operation, :description)
            .merge(user: current_user,
                   banner_store: BannerStore.ads_store,
                   premium: true,
                   active: false,
                   status: :pendent,
                   order: current_ads_cart,
                   current_clicks: @product.clicks)
    end
  end
end
