class LastActiveSponsoredUserQuery

  def initialize(sponsor)
    @sponsor = sponsor
  end

  def call
    node = BinaryNode.where(sponsored_by: sponsor).order(created_at: :desc).first
    node.user if node
  end

  private

  attr_reader :sponsor

end
