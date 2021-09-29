module Main
  module Entities
    class Image < ROM::Struct
      attribute :image_data, HanfBrett::Types::String.default('{}'.freeze)

      include HanfBrett::ImageUploader::Attachment(:image)

      # def image_data=(image_data)
      #   attributes[:image_data] = image_data
      # end

      def image_data
        JSON.parse(attributes[:image_data].to_json, object_class: OpenStruct)
      end
    end
  end
end
