class CalculateUserActivityBonusRange

  def initialize(user)
    @user = user
  end

  def call
    if pvv_score_first_gen >= 1000 && pvv_score_first_gen < 4999
      0.15
    elsif pvv_score_first_gen >= 5_000
      0.20
    elsif user.active?
      0.10
    else
      0
    end
  end

  private

  attr_reader :user

  def pvv_score_first_gen
    @pvv_score_first_gen ||= user.pv_activity_histories.where(
      'created_at > ?', 30.days.ago.beginning_of_day
    ).where(kind: :pvv).sum(:amount)
  end

end
