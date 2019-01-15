module Backoffice
  class InvestmentsController < BackofficeController

    def index
      @investments = Investment.all
    end

    def buy
      if quantity <= investment.shares_available
        Investments::Buy.new(user: current_user, investment: investment, quantity: quantity).call
        flash[:success] = 'Contas de investimento adquiridas com sucesso'
        redirect_to backoffice_orders_path
      else
        flash[:error] = 'Não foi possível adquirir as contas'
        redirect_to backoffice_investments_path
      end
    end

    private

    def investment
      @investment ||= Investment.find(params[:id])
    end

    def quantity
      params[:quantity].to_i
    end

  end
end
