module Backoffice
  class PayWithVoucherController < BackofficeController

    before_action :verify_user_active

    def new
      render_new
    end

    def create
      if form.valid?
        Vouchers::Apply.new(
          order: form.order,
          payer: form.user,
          voucher: form.voucher
        ).call

        flash[:success] = 'Voucher utilizado com sucesso!'
        redirect_to backoffice_orders_path
      else
        render_new
      end
    end

    private

    def render_new
      render(:new, locals: { form: form })
    end

    def form
      @form ||= PayWithVoucherForm.new(form_params)
    end

    def form_params
      params[:pay_with_voucher_form] ||= {}
      params[:pay_with_voucher_form][:user] ||= current_user
      params[:pay_with_voucher_form]
    end

    def verify_user_active
      return if current_user.active?

      redirect_back(fallback_location: root_path, alert: 'Usuários inativos não podem pagar com voucher')
    end

  end
end
