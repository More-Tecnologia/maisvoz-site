class AssociateSupportPointService < ApplicationService

  def call
    return unless support_point_users.any?
    last_support_point_receiver = find_last_support_point_receiver_by(user.city, user.state)
    support_point_user =
      detect_next_support_point_user_to_receive_user(last_support_point_receiver)
    add_user_to(support_point_user) if support_point_user
  end

  private

  attr_accessor :user, :support_point_users

  def initialize(args)
    @user = args[:user]
    @support_point_users = find_support_point_users_by(user.city, user.state)
  end

  def find_support_point_users_by(city, state)
    User.support_point
        .by_location(city, state)
        .order(:id)
  end

  def find_last_support_point_receiver_by(city, state)
    last_adhesion_user = User.bought_adhesion
                             .where(city: city, state: state)
                             .order(:id)
                             .last(2)
                             .first
    last_adhesion_user.try(:support_point_user)
  end

  def detect_next_support_point_user_to_receive_user(last_support_point_receiver)
    return support_point_users.first unless last_support_point_receiver
    users = support_point_users.compact.uniq.cycle(2).to_a
    index = users.index(last_support_point_receiver)
    users[index + 1]
  end

  def add_user_to(support_point_user)
    user.update!(support_point_user: support_point_user)
  end

end
