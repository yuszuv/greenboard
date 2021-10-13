# frozen_string_literal: true

require 'dry/monads'

module Api
  module Actions
    class GetCard < Api::Action
      include Deps[
        'operations.get_card'
      ]

      def handle(req, res)
        case get_card.(req.params[:id])
        in Success(card)
          res.status = 200
          res.body = card
            .to_h
            .reject{ |k,_| k == :password }
            .to_json
        in Failure(:not_found)
          res.status = 404
        in Failure(:db | :storage, error)
          logger.error(error.inspect)
          res.status = 500
          res.body = "server error"
        end
      end
    end
  end
end
