# frozen_string_literal: true

module Main
  module Actions
    class DeleteSubscription < Main::Action
      include Deps[
        'application.logger',
        'operations.delete_subscription',
        view: 'views.delete_subscription',
      ]

      def handle(req, res)
        case delete_subscription.(req.params.to_h)
        in Success(subscriber)
          res.render view
        in Failure(:not_found)
          res.status = 404
        in Failure(:validation, errors)
          res.status = 400
          res.body = errors.to_json
        in Failure(*x)
          logger.error(x)
          res.status = 500
        end
      end
    end
  end
end
