module Backoffice
  module Admin

    class CellphoneReloadsController < AdminController

      include CellphoneReloadsHelper

      def index
        @q = OrderItem.ransack(params[:q])
        respond_to do |format|
          format.html { @cellphone_reloads = find_cellphone_reloads_to_html(@q) }
          format.csv { render_reloads_as_csv(find_cellphone_reloads_to_csv(@q)) }
        end
      end

    end

  end
end
