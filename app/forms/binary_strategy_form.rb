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

  private

  def valid_binary_positions
    return if binary_positions.blank?
    binary_positions.each do |k, v|
      user = User.find(k)
      if user.sponsor != sponsor
        errors.add(:binary_positions, I18n.t('defaults.errors.different_sponsor'))
        return
      end
    end
  end

end
