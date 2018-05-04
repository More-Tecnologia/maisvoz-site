module Backoffice
  class PayThirdOrderController < BackofficeController

    def new
      render_new
    end

    def create
      if form.valid?
        Financial::PayThirdOrder.call(form)
        flash.now[:success] = 'Fatura paga com sucesso'
        render(:new, locals: { form: PayThirdOrderForm.new })
      else
        flash.now[:error] = 'Verifique os erros abaixo'
        render_new
      end
    end

    private

    def render_new
      render :new, locals: { form: form }
    end

    def form
      @form ||= PayThirdOrderForm.new(form_params)
    end

    def form_params
      params[:pay_third_order_form]         ||= {}
      params[:pay_third_order_form][:payer] ||= current_user
      params[:pay_third_order_form]
    end

  end
end
