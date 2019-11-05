class FinancialTransactionPolicy

  def initialize(user)
    @user = user
  end

  def current_month_bonus
    @current_month_bonus ||= current_month_bonus_sum
  end

  private

  attr_reader :user

  def current_month_bonus_sum
    not_chargeback_sum = user.financial_transactions
                             .not_chargeback
                             .where('created_at >= ?', beginning_of_month)
                             .sum(:cent_amount)
    chargeback_sum = user.financial_transactions
                         .chargeback
                         .where('created_at >= ?', beginning_of_month)
                         .sum(:cent_amount)
    not_chargeback_sum - chargeback_sum
  end

  def beginning_of_month
    Time.zone.now.beginning_of_month
  end

end
