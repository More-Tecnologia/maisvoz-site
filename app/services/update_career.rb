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
  end

  private

  attr_reader :form, :career

  def update_career
    career.update!(form.attributes)
  end

end
