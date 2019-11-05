class LastActiveSponsoredUserQuery

  def initialize(sponsor)
    @sponsor = sponsor
  end

  def call
    node = sponsor.binary_node.children.last
    node.user if node
  end

  private

  attr_reader :sponsor

end
