require 'rom/struct'

module Api
  module Entities
    class PublicCard < ROM::Struct
      attribute :id, HanfBrett::Types::Coercible::String
      attribute :type, HanfBrett::Types::CardType
      attribute :topic, HanfBrett::Types::String
      attribute :text, HanfBrett::Types::String
      attribute :images, HanfBrett::Types::Array
      attribute :timestamp, HanfBrett::Types::Integer
    end
  end
end
