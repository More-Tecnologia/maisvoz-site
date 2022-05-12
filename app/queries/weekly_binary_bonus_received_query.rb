class WeeklyBinaryBonusReceivedQuery

  def initialize(user)
    @user = user
  end

  def call
    chargebacks_sum = user.financial_transactions
                          .chargeback
                          .where('created_at >= ?', beginning_of_week)
                          .sum(:cent_amount)
    not_chargebacks_sum = user.financial_transactions
                              .not_chargeback
                              .where('created_at >= ?', beginning_of_week)
                              .sum(:cent_amount)
    not_chargebacks_sum - chargebacks_sum
  end

  private

  attr_reader :user

  def beginning_of_week
    Time.zone.now.beginning_of_week
  end

end
