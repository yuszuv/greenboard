# frozen_string_literal: true

module Main
  module Operations
    class UploadImage < HanfBrett::Operation
      include Deps[
        contract: 'contracts.images.upload',
      ]

      def call(input)
        data = yield validate(input)
        image = yield upload_image(data)

        Success(image)
      end

      private

      def validate(input)
        contract.(input).to_monad.to_result.or do |result|
          Failure[:validation, result.errors(full: true).to_h.to_json]
        end
      end

      def upload_image(data)
        attacher = HanfBrett::ImageUploader::Attacher.new
        attacher.assign(Shrine.rack_file(data[:file]))
        if attacher.validate
          attacher.create_derivatives
          attacher.finalize
          Success(attacher)
        else
          Failure[:validation, attacher.errors]
        end
      end
    end
  end
end
