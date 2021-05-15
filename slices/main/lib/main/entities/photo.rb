module Main
  module Entities
    class Photo < ROM::Struct
      attribute :image_data, HanfBrett::Types::String.default('{}'.freeze)

      include HanfBrett::ImageUploader::Attachment(:image)

      def image_data=(image_data)
        attributes[:image_data] = image_data
      end
    end
  end
end
