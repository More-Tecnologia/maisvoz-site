class ClubMotorsSubscriptionPolicy

  def initialize(club_motors_subscription)
    @club_motors_subscription = club_motors_subscription
  end

  def can_edit?
    club_motors_subscription.provide_info? ||
      club_motors_subscription.pending?
  end

  private

  attr_reader :club_motors_subscription

end
