# frozen_string_literal: true

require 'dry/monads'

module Api
  module Actions
    class CreateCard < Api::Action
      include Deps[
        'application.logger',
        'operations.create_card'
      ]

      def handle(req, res)
        case create_card.(req.params.to_h)
        in Success(card)
          res.status = 201
          res.body = card.to_h.to_json
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        in Failure(:db | :storage, error)
          logger.error(error.inspect)
          res.status = 500
          res.body = "server error"
        end
      end
    end
  end
end
