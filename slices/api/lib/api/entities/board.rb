require 'rom/struct'

module Api
  module Entities
    class Board < ROM::Struct
      attribute :stuff, HanfBrett::Types::String
      attribute :offers, HanfBrett::Types::Array.of(Entities::PublicCard)
    end
  end
end
