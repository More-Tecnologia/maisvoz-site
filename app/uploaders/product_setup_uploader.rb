require "image_processing/mini_magick"

class ProductSetupUploader < Shrine
  ALLOWED_TYPES = %w[image/jpeg image/jpg image/png]
  MAX_SIZE      = 2*1024*1024 # 2 MB

  plugin :remove_attachment
  plugin :delete_promoted
  plugin :delete_raw
  plugin :pretty_location
  plugin :processing
  plugin :versions
  plugin :validation_helpers
  plugin :store_dimensions, analyzer: :mini_magick

  Attacher.validate do
    validate_max_size MAX_SIZE
    if validate_mime_type_inclusion(ALLOWED_TYPES)
      validate_max_width 5000
      validate_max_height 5000
    end
  end

  process(:store) do |io, context|
    puts 'processing'
    original = io.download
    
    thumbnail = ImageProcessing::MiniMagick
      .source(original)
      .resize_to_limit!(100, 100)
    
    original.close!
    
    puts 'processing done!'

    { original: io, thumbnail: thumbnail }
  end
end