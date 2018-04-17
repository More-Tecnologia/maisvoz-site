class UpdateCareer

  def initialize(form, career)
    @form = form
    @career = career
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      update_career
    end
    true
  end

  private

  attr_reader :form, :career

  def update_career
    career.update!(form_attributes)
  end

  def form_attributes
    form.attributes
  end

end
