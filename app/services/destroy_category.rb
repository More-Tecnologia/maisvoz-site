class DestroyCategory

  def initialize(category)
    @category = category
  end

  def call
    destroy_category
  end

  private

  attr_reader :category

  def destroy_category
    category.destroy!
  end

end
