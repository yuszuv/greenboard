module Frontend
  module Entities
    class Image < ROM::Struct
      attribute :image_data, HanfBrett::Types::String.default('{}'.freeze)

      include HanfBrett::ImageUploader::Attachment(:image)
    end
  end
end
