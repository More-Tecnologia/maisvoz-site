class DestroyCareer

  def initialize(career)
    @career = career
  end

  def call
    destroy_career
  end

  private

  attr_reader :career

  def destroy_career
    career.destroy!
  end

end
