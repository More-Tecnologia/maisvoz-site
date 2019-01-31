class ClubMotorsSubscriptionPolicy

  def initialize(user, club_motors_subscription)
    @user = user
    @club_motors_subscription = club_motors_subscription
  end

  def can_edit?
    club_motors_subscription.chassis.blank? &&
      user.active? &&
      owner?
  end

  def can_remove?
    club_motors_subscription.inactive? &&
      club_motors_subscription.chassis.blank? &&
      !club_motors_subscription.tracker? &&
      owner?
  end

  private

  attr_reader :club_motors_subscription, :user

  def owner?
    @owner ||= club_motors_subscription.user == user
  end

end
