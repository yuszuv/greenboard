# frozen_string_literal: true

require 'dry/monads'

module Api
  module Actions
    class UpdateCard < Api::Action
      include Dry::Monads[:result]
      include Deps[
        'application.logger',
        'operations.update_card',
      ]

      def handle(req, res)
        case update_card.(req.params.to_h)
        in Success(card)
          res.status = 200
          res.body = card.to_h.to_json
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        in Failure(:authorization, errors)
          res.status = 403
          res.body = errors.to_json
        in Failure(:db, error)
          logger.error(error.message)
          res.status = 500
        in Failure(x)
          res.status = 500
          res.body = x.errors
        end
      end
    end
  end
end
