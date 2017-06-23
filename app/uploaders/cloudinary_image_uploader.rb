class CloudinaryImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process convert: 'png'

  version :standard do
    process resize_to_fill: [800, 800]
  end

  version :thumbnail do
    resize_to_fit(100, 100)
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

end
