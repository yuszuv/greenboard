# frozen_string_literal: true

require 'dry/monads'

module Api
  module Actions
    class AuthorizeCard < Api::Action
      include Deps[
        'application.logger',
        'operations.authorize_card'
      ]

      def handle(req, res)
        case authorize_card.(req.params[:id], req.params[:password])
        in Success()
          res.status = 200
        in Failure(:unauthorized | :not_found)
          res.status = 403
        in Failure(:db | :storage, error)
          logger.error(error.inspect)
          res.status = 500
          res.body = "server error"
        end
      end
    end
  end
end
