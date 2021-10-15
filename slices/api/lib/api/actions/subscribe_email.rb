# frozen_string_literal: true

module Api
  module Actions
    class SubscribeEmail < Api::Action
      include Deps[
        subscribe_email: 'operations.subscribe_email'
      ]

      def handle(req, res)
        case subscribe_email.(req.params.to_h)
        in Success(_)
          res.status = 200
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        else
          res.status = 500
        end
      end
    end
  end
end


