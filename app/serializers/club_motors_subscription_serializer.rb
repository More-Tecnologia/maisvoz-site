class ClubMotorsSubscriptionSerializer

  def initialize(club_motors_subscription)
    @club_motors_subscription = club_motors_subscription
  end

  def serialize
    {
      id: club_motors_subscription.id,
      user_id: club_motors_subscription.user_id,
      chassis: club_motors_subscription.chassis,
      renavam: club_motors_subscription.renavam,
      approved_by_username: club_motors_subscription.approved_by_username,
      plate: club_motors_subscription.plate,
      cnpj_cpf: club_motors_subscription.cnpj_cpf,
      status: club_motors_subscription.status,
      type: club_motors_subscription.type,
    }.to_json
  end

  private

  attr_reader :club_motors_subscription
end
