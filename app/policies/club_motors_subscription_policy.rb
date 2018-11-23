class ClubMotorsSubscriptionPolicy

  def initialize(club_motors_subscription)
    @club_motors_subscription = club_motors_subscription
  end

  def can_edit?
    club_motors_subscription.chassis.blank?
  end

  private

  attr_reader :club_motors_subscription

end
