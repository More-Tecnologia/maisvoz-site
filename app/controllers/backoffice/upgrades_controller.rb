module Backoffice
  class UpgradesController < EntrepreneurController

    before_action :verify_user_has_package

    def new
      render_new
    end

    def create
      if form.valid?
        Subscriptions::CreateUpgrade.new(form: form).call

        flash[:success] = 'Compra realizada'
        redirect_to backoffice_orders_path
      else
        render_new
      end
    end

    private

    def render_new
      render(:new, locals: { form: form, upgrades: upgrades, current_package_price: current_package_price })
    end

    def upgrades
      @upgrades = Product.adhesion.where('price_cents > ?', current_package_price_cents)
    end

    def current_package_price
      current_package_price_cents / 1e2
    end

    def current_package_price_cents
      current_user.product.price_cents
    end

    def form
      @form ||= UpgradeForm.new(user: current_user)
      @form.attributes = form_params
      @form
    end

    def form_params
      params[:upgrade_form] ||= {}
      params[:upgrade_form]
    end

    def verify_user_has_package
      return if current_user.product.present?

      flash[:error] = 'Para realizar o upgrade você precisa ter adquirido um pacote de adesão'
      redirect_to new_backoffice_club_motor_path
    end

  end
end
