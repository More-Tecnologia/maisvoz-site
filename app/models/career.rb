# == Schema Information
#
# Table name: careers
#
#  id                :integer          not null, primary key
#  name              :string
#  qualifying_score  :integer          default(0)
#  bonus             :integer          default(0)
#  binary_limit      :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  kind              :integer          default("qualification"), not null
#  binary_percentage :decimal(5, 2)    default(0.0), not null
#  image_path        :string
#

class Career < ApplicationRecord

  enum kind: [:qualification, :adhesion]

  has_one :cloudinary_image, as: :imageable

  has_many :products
  has_many :binary_nodes

  def thumbnail
    return CloudinaryImage.new.public_id unless cloudinary_image.present?
    cloudinary_image.public_id.thumbnail
  end

end
