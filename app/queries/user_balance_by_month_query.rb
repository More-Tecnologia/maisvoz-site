class UserBalanceByMonthQuery

  def initialize(user, ref_date)
    @user     = user
    @ref_date = ref_date
  end

  def call
    credited_bonus + reversed_bonus
  end

  private

  delegate :beginning_of_month, :end_of_month, to: :ref_date

  attr_reader :user, :ref_date

  def credited_bonus
    @credited_bonus ||= user.financial_transactions.where(
      'cent_amount > 0'
    ).where(
      'created_at >= ? OR created_at <= ?', beginning_of_month, end_of_month
    ).sum(:cent_amount)
  end

  def reversed_bonus
    @reversed_bonus ||= user.financial_transactions.where(
      'cent_amount < 0'
    ).where(
      'created_at >= ? OR created_at <= ?', beginning_of_month, end_of_month
    ).sum(:cent_amount)
  end

end
