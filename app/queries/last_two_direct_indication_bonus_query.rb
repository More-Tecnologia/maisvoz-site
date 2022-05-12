class LastTwoDirectIndicationBonusQuery

  def initialize(user)
    @user = user
  end

  def call
    user.financial_entries.direct_indication_bonus.where(
      'DATE(created_at) >= ?', 7.days.ago.to_date
    ).where(
      'amount_cents > 0'
    ).order(:created_at).first(2)
  end

  private

  attr_reader :user

end
