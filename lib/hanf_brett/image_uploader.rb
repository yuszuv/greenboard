# auto_register: false
#
require "image_processing/mini_magick"

Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives
Shrine.plugin :store_dimensions

module HanfBrett
  class ImageUploader < Shrine
    Attacher.validate do
      validate_size      1..5*1024*1024
      validate_mime_type %w[image/jpeg image/png image/webp image/tiff]
      validate_extension %w[jpg jpeg png webp tiff tif]
    end

    Attacher.derivatives do |original|
      magick = ImageProcessing::MiniMagick.source(original)

      {
        large:  magick.resize_to_limit!(800, 800),
        medium: magick.resize_to_limit!(500, 500),
        small:  magick.resize_to_limit!(300, 300),
        # thumbnail:  magick.resize_to_fill!(200, 200),
        thumbnail:  magick.resize_to_limit!(nil, 200),
      }
    end

#     # plugins and uploading logic 
#     def initialize
#       super(:store)
#     end
  end
end
