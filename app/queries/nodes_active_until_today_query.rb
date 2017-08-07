class NodesActiveUntilTodayQuery

  def initialize(date)
    @date = date
  end

  def find_each(&block)
    BinaryNode.where(
      active: true
    ).where(
      'active_until <= ?', date
    ).find_each(&block)
  end

  private

  attr_reader :date

end
