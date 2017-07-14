class BinaryStrategyForm < Form

  attribute :sponsor, User
  attribute :binary_strategy
  attribute :binary_positions

  validate :valid_binary_positions

  def sponsored_users_not_in_binary
    @sponsored_users_not_in_binary ||= SponsoredUsersNotInBinaryQuery.new(
      sponsor
    ).call
  end

end
