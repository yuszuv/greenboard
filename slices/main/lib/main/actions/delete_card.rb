# frozen_string_literal: true

require 'dry/monads'

module Main
  module Actions
    class DeleteCard < Main::Action
      include Dry::Monads[:result]
      include Deps[
        'application.logger',
        'operations.delete_card',
        view: 'views.cards.confirm_delete'
      ]

      def handle(req, res)
        input = req.params.to_h
        case delete_card.(input)
        in Success(card)
          res.flash[:success] = "Eintrag wurde gelöscht 🎉"
          res.redirect_to '/'
        in Failure(:authorization, id, errors)
          res.flash.now[:alert] = "Uuuuups!!!! Fehler"
          res.render view, id: id, errors: errors
        in Failure(:db, error)
          logger.error(error.inspect)
          res.status = 500
          res.body = "server error"
        end
      end
    end
  end
end
