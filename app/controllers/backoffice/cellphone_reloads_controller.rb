module Backoffice
  class CellphoneReloadsController < BackofficeController

    include CellphoneReloadsHelper

    def new
      @cellphone_reload = CellphoneReloadForm.new
    end

    def create
      @cellphone_reload = CellphoneReloadForm.new(valid_params)
      if @cellphone_reload.valid?
        order = create_reload_order(@cellphone_reload)
        redirect_to backoffice_order_path(order)
      else
        flash[:error] = @cellphone_reload.errors.full_messages.join(', ')
        redirect_to new_backoffice_cellphone_reload_path
      end
    end

    private

    def valid_params
      params.require(:cellphone_reload_form).permit(:product_id, :ddd, :cellphone_number)
    end

  end
end
