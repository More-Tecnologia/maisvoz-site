

module Backoffice
  class HomeController < EntrepreneurController
    before_action :ensure_no_admin_user, only: :index
    before_action :ensure_contracts, only: :index

    def index
      contract = @contracts.last
      total_banners_per_day = contract.present? ? contract.order_items.last.task_per_day.to_i : 0
      banners_clicked_today_quantity = current_user.banner_clicks
                                                   .today
                                                   .by_contract(contract)
                                                   .count
      remaing_clicks = total_banners_per_day - banners_clicked_today_quantity
      @tasks_done = remaing_clicks.zero?
    end

    private

    def ensure_contracts
      @contracts = current_user.bonus_contracts.active.sort do |contract, other|
        contract.order_items.last.task_per_day.to_i <=> other.order_items.last.task_per_day.to_i
      end
    end

    def ensure_no_admin_user
      redirect_to backoffice_admin_dashboard_index_path if user_signed_in? && (current_user.admin? || current_user.financeiro? || current_user.suporte?)
    end

  end
end
