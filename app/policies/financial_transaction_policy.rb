class FinancialTransactionPolicy

  LIMIT = 660_000

  def initialize(user)
    @user = user
  end

  def monthly_limit_reached?(amount = 0)
    amount_received_this_month + amount >= LIMIT
  end

  def amount_left
    LIMIT - amount_received_this_month
  end

  private

  attr_reader :user

  def amount_received_this_month
    @amount_received_this_month ||= user
                                    .financial_transactions
                                    .where('cent_amount > 0')
                                    .where('created_at >= ?', beginning_of_month)
                                    .sum(:cent_amount) / 100.0
  end

  def beginning_of_month
    Time.zone.now.beginning_of_month
  end

end
