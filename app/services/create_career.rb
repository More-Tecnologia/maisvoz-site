class CreateCareer

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      create_career
      create_cloudinary_image
    end
    true
  end

  private

  attr_reader :form, :career

  def create_career
    @career = Career.new(form_attributes)
    career.save!
  end

  def create_cloudinary_image
    CreateOrUpdateClImage.new(career, career.cloudinary_image, form.public_id).call
  end

  def form_attributes
    form.attributes.except(:public_id)
  end

end
