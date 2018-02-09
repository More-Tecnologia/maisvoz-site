class WeeklyBinaryBonusReceivedQuery

  def initialize(user)
    @user = user
  end

  def call
    user
      .financial_entries
      .where('kind = ? OR kind = ?', :binary_bonus, :reverse_binary_bonus)
      .where('created_at >= ?', beginning_of_week)
      .sum(:amount_cents).to_i / 1e2
  end

  private

  attr_reader :user

  def beginning_of_week
    Time.zone.now.beginning_of_week
  end

end
