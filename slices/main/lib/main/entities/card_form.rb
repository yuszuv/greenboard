module Main
  module Entities
    class CardForm < Dry::Struct
      attribute :id, HanfBrett::Types::Integer.optional
      attribute :type, HanfBrett::Types::String
      attribute :topic, HanfBrett::Types::String
      attribute :text, HanfBrett::Types::String
      attribute :author, HanfBrett::Types::String

      Empty = new(id: nil, type: '', topic: '', text: '', author: '')
    end
  end
end
