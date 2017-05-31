class CareersQuery

  def initialize(relation = Career.all)
    @careers = relation
  end

  def call
    careers
  end

  private

  attr_reader :careers

end
