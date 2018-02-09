class CalculateBinaryBonusLimit

  LIMITS = {
    executive: 900,
    bronze: 1500,
    silver: 2100,
    gold: 2700,
    ruby: 4300,
    emerald: 5200,
    diamond: 6400,
    white_diamond: 7600,
    blue_diamond: 10_000,
    black_diamond: 20_000,
    chairman_club: 30_000,
    chairman_club_two_star: 35_000,
    chairman_club_three_star: 40_000
  }.freeze

  def initialize(user)
    @user = user
  end

  def call
    LIMITS.fetch(user.career_kind.to_sym)
  end

  private

  attr_reader :user

end
