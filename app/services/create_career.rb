class CreateCareer

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      create_career
    end
    true
  end

  private

  attr_reader :form, :career

  def create_career
    @career = Career.new(form_attributes)
    career.save!
  end

  def form_attributes
    form.attributes
  end

end
