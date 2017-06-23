class CloudinaryImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process convert: 'png'

  version :standard do
    process resize_to_fit: [800, 800]
  end

  version :thumbnail do
    resize_to_fit(100, 100)
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end

end
