class UpdateCategory

  def initialize(form, category)
    @form = form
    @category = category
  end

  def call
    return false unless form.valid?
    update_category
  end

  private

  attr_reader :form, :category

  def update_category
    category.update!(form.attributes)
  end

end
