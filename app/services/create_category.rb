class CreateCategory

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    create_category
  end

  private

  attr_reader :form, :category

  def create_category
    @category = Category.new(form.attributes)
    category.save!
  end

end
