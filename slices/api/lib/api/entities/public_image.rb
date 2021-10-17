require 'rom/struct'

module Api
  module Entities
    class PublicImage < ROM::Struct
      attribute :id, HanfBrett::Types::Coercible::String
      attribute :url, HanfBrett::Types::String
      attribute :thumbnail_url, HanfBrett::Types::String

      attribute :height, HanfBrett::Types::Integer
      attribute :width, HanfBrett::Types::Integer
    end
  end
end
