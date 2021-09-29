# frozen_string_literal: true

require 'dry/monads'

module Main
  module Actions
    class UploadImage < Main::Action
      include Dry::Monads[:result]
      include Deps[
        'operations.upload_image'
      ]

      config.default_response_format = :json

      def handle(req, res)
        input = req.params.to_h
        case upload_image.(input)
        in Success(image)
          res.body = image.column_data
        in Failure(:validation, errors)
          res.status = 406
          res.body = errors
        in Failure(:authorization, form, errors)
          # FIXME: form is no form
          res.render view, form: form, errors: errors
        in Failure(:db, error)
          logger.error(error.message)
        in Failure(x)
          res.status = 500
          res.body = x.inspect
        end
      end
    end
  end
end

