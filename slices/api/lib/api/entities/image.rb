module Api
  module Entities
    class Image < ROM::Struct
      attribute :image_data, HanfBrett::Types::String.default('{}'.freeze)
    end
  end
end
