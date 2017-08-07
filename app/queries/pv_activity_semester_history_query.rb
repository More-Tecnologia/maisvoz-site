class PvActivitySemesterHistoryQuery

  def initialize(user, until_date)
    @user = user
    @until_date = until_date
  end

  def call
    PvActivityHistory.where(
      user: user
    ).where(
      'DATE(created_at) >= ?', six_months_ago
    ).where(
      'DATE(created_at) <= ?', until_date
    )
  end

  private

  attr_reader :user, :until_date

  def six_months_ago
    until_date - 6.months
  end

end
