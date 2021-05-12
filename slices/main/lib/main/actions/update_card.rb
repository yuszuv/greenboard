# frozen_string_literal: true

require 'dry/monads'

module Main
  module Actions
    class UpdateCard < Main::Action
      include Dry::Monads[:result]
      include Deps[
        'application.logger',
        'operations.update_card',
        get_form: 'operations.fetch_form_data',
        view: 'views.cards.form'
      ]

      def handle(req, res)
        input = req.params.to_h
        case update_card.(input)
        in Success(card)
          res.redirect_to '/gruenes_brett'
        in Failure(:validation, form, errors)
          res.render view, form: form, errors: errors
        in Failure(:authorization, form, errors)
          res.render view, form: form, errors: errors
        in Failure(:db, error)
          logger.error(error.message)
        in Failure(x)
          res.body = x.errors
        end
      end
    end
  end
end
