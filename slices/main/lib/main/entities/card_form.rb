module Main
  module Entities
    class CardForm < Dry::Struct
      attribute :id, HanfBrett::Types::Integer.optional
      attribute :type, HanfBrett::Types::String
      attribute :topic, HanfBrett::Types::String
      attribute :text, HanfBrett::Types::String
      attribute :author, HanfBrett::Types::String
      attribute :images, HanfBrett::Types::Array.of(HanfBrett::Types::String).default([])

      # attribute :photos, HanfBrett::Types::Array.of(
      #   HanfBrett::Types::Hash.schema(
      #     id: HanfBrett::Types::Integer
      #   )
      # )
      # include HanfBrett::ImageUploader::Attachment(:image) # adds an `image` virtual attribute 

      # def image_data=(image_data)
      #   attributes[:image_data] = image_data
      # end

      Empty = new(id: nil, type: '', topic: '', text: '', author: '', images: [])
    end
  end
end
