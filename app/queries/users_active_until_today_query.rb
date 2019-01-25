class UsersActiveUntilTodayQuery

  def initialize(date)
    @date = date
  end

  def find_each(&block)
    User.where(
      'active_until <= ?', date.to_date
    ).find_each(&block)
  end

  private

  attr_reader :date

end
