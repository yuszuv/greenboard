module Main
  module Entities
    class CardForm < Dry::Struct
      attribute :id, HanfBrett::Types::Integer.optional
      attribute :type, HanfBrett::Types::String
      attribute :topic, HanfBrett::Types::String
      attribute :text, HanfBrett::Types::String
      attribute :author, HanfBrett::Types::String
      attribute :image_data, HanfBrett::Types::String.default('{}'.freeze)

      include HanfBrett::ImageUploader::Attachment(:image) # adds an `image` virtual attribute 

      def image_data=(image_data)
        attributes[:image_data] = image_data
      end

      Empty = new(id: nil, type: '', topic: '', text: '', author: '')
    end
  end
end
