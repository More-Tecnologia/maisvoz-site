class CreateCareer

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      create_career
    end
  end

  private

  attr_reader :form, :career

  def create_career
    @career = Career.new(form.attributes)
    career.save!
  end

end
