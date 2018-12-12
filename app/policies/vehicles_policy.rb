class VehiclesPolicy

  MAX_VEHICLES = 5

  def initialize(user:)
    @user = user
  end

  def can_add?
    user_vehicles_count < MAX_VEHICLES
  end

  private

  attr_reader :user

  def user_vehicles_count
    user.club_motors_subscriptions.count
  end

end