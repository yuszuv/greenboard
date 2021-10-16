# frozen_string_literal: true

module Api
  module Actions
    class SubscribeUpdates < Api::Action
      include Deps[
        'operations.subscribe_updates'
      ]

      def handle(req, res)
        case subscribe_updates.(req.params.to_h)
        in Success(_)
          res.status = 200
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        in Failure(:mail, errors)
          res.status = 500
        else
          res.status = 500
        end
      end
    end
  end
end


