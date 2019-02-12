class ClubMotorsNewSubscriptionForm < Form

  attribute :user
  attribute :club_motors_id
  attribute :terms_of_service

  validates :club_motors_id, presence: true
  validates :terms_of_service, acceptance: true

  def club_motors_list
    @club_motors_list ||= Product.active.club_motors.order(:price_cents)
  end

  def club_motors
    return if club_motors_id.blank?

    @club_motors ||= Product.find(club_motors_id)
  end

end
