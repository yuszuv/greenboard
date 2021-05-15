# auto_register: false
#
require "image_processing/mini_magick"

Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives

module HanfBrett
  class ImageUploader < Shrine
    Attacher.validate do
      validate_extension %w[jpg jpeg png webp tiff tif]
      # ... perform validation ... 
    end

    Attacher.derivatives do |original|
      magick = ImageProcessing::MiniMagick.source(original)

      {
        large:  magick.resize_to_limit!(800, 800),
        medium: magick.resize_to_limit!(500, 500),
        small:  magick.resize_to_limit!(300, 300),
        thumbnail:  magick.resize_to_fill!(200, 200),
      }
    end

#     # plugins and uploading logic 
#     def initialize
#       super(:store)
#     end
  end
end
