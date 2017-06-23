class CreateOrUpdateClImage

  def initialize(resource, cloudinary_image, new_image_public_id)
    @resource = resource
    @cloudinary_image = cloudinary_image
    @new_image_public_id = new_image_public_id
  end

  def call
    return false if cloudinary_image.try(:public_id) == new_image_public_id || new_image_public_id.blank?
    ActiveRecord::Base.transaction do
      destroy_old_cl_image
      create_cl_image
    end
  end

  private

  attr_reader :resource, :cloudinary_image, :new_image_public_id

  def destroy_old_cl_image
    return if cloudinary_image.blank?
    cloudinary_image.remove_public_id!
    cloudinary_image.destroy!
  end

  def create_cl_image
    image = CloudinaryImage.new(public_id: new_image_public_id)
    image.imageable = resource
    image.save!
  end

end
