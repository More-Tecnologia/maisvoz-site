class PvActivityHistoryQuery

  def initialize(user, relation = PvActivityHistory.all, period = 30)
    @user     = user
    @relation = relation
    @period   = period
  end

  def call
    relation
      .where(user: user)
      .where('created_at >= ?', period.days.ago)
  end

  private

  attr_reader :user, :relation, :period

end
