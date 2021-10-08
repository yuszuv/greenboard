# frozen_string_literal: true

require 'dry/monads'

module Main
  module Actions
    class CreateCard < Main::Action
      include Dry::Monads[:result]
      include Deps[
        'application.logger',
        'operations.create_card',
        view: 'views.cards.form'
      ]

      def handle(req, res)
        input = req.params.to_h
        case create_card.(input)
        in Success(card)
          res.flash[:success] = "Neuer Eintrag wurde erstellt 🎉"
          res.redirect_to '/'
        in Failure(:validation, form, errors)
          res.flash.now[:alert] = "Uuuuups!!!! Fehler"
          res.render view, form: form, errors: errors
        in Failure(:db | :storage, error)
          logger.error(error.inspect)
          res.status = 500
          res.body = "server error"
        end
      end
    end
  end
end
