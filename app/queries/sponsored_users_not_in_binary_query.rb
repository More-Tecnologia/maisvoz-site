class SponsoredUsersNotInBinaryQuery

  def initialize(sponsor)
    @sponsor = sponsor
  end

  def call
    User.where(sponsor: sponsor).order(:id) - sponsored_and_present
  end

  private

  attr_reader :sponsor

  def sponsored_and_present
    User.where(sponsor: sponsor).joins(:binary_node)
  end

end
