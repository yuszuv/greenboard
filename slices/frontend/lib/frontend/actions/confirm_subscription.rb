# frozen_string_literal: true

module Frontend
  module Actions
    class ConfirmSubscription < Frontend::Action
      include Deps[
        'application.logger',
        'operations.confirm_subscription',
        view: 'views.confirm_subscription',
      ]

      def handle(req, res)
        case confirm_subscription.(req.params.to_h)
        in Success(subscriber)
          res.render view, subscriber: subscriber
        in Failure(:not_found)
          res.status = 404
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        in Failure(x)
          res.body = x.errors
        end
      end
    end
  end
end
