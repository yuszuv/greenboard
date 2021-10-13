# frozen_string_literal: true

require 'dry/monads'

module Api
  module Actions
    class DeleteCard < Api::Action
      include Dry::Monads[:result]
      include Deps[
        'application.logger',
        'operations.delete_card',
      ]

      def handle(req, res)
        case delete_card.(req.params.to_h)
        in Success(card)
          res.status = 200
        in Failure(:not_found)
          res.status = 404
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        in Failure(:unauthorized)
          res.status = 403
        in Failure(:db, error)
          logger.error(error.message)
          res.status = 500
        in Failure(x)
          res.status = 500
          logger.error(x)
        end
      end
    end
  end
end
