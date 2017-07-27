class UpdateCareer

  def initialize(form, career)
    @form = form
    @career = career
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      update_career
      cl_update
    end
    true
  end

  private

  attr_reader :form, :career

  def update_career
    career.update!(form_attributes)
  end

  def cl_update
    CreateOrUpdateClImage.new(career, career.cloudinary_image, form.public_id).call
  end

  def form_attributes
    form.attributes.except(:public_id)
  end

end
