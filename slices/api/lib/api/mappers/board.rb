require 'dry/core/constants'

module Api
  module Mappers
    class Board < HanfBrett::Mapper
      include Dry::Core::Constants

      define! do
        map_array do |args|
          accept_keys [
            :id,
            :type,
            :topic,
            :text,
            :images
          ]
          map_value :images do
            map_array do |image|
              deep_symbolize_keys
              transform_object ->{ _1.merge(image: HanfBrett::ImageUploader::Attacher.from_data(_1[:image_data])) }
              copy_keys image: [:url, :thumbnail_url, :width, :height]
              map_value :url, :url.to_proc
              map_value :thumbnail_url, ->{ _1.derivatives[:thumbnail].url }
              map_value :height, :file.to_proc >> :height.to_proc
              map_value :width, :file.to_proc >> :width.to_proc

              bind Undefined, ->(args){ Entities::PublicImage.new(args.to_h) }
            end
          end
          bind Undefined, ->(args){ Entities::PublicCard.new(args.to_h) }
        end
      end
    end
  end
end
