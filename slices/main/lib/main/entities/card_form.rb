module Main
  module Entities
    class CardForm < Dry::Struct
      attribute :id, HanfBrett::Types::Integer.optional
      attribute :type, HanfBrett::Types::String
      attribute :topic, HanfBrett::Types::String
      attribute :text, HanfBrett::Types::String
      attribute :contact, HanfBrett::Types::String
      # attribute :author, HanfBrett::Types::String
      attribute :images, HanfBrett::Types::Array.of(HanfBrett::Types::Hash).default([])

      Empty = new(id: nil, type: '', topic: '', text: '', contact: '', author: '', images: [])
    end
  end
end
