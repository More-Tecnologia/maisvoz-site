# == Schema Information
#
# Table name: cloudinary_images
#
#  id             :integer          not null, primary key
#  public_id      :string
#  imageable_type :string
#  imageable_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_cloudinary_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

class CloudinaryImage < ApplicationRecord

  belongs_to :imageable, polymorphic: true
  mount_uploader :public_id, CloudinaryImageUploader

end
