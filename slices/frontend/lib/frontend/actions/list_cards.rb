# frozen_string_literal: true

module Frontend
  module Actions
    class ListCards < Frontend::Action
      include Deps[
        'application.logger',
        view: 'views.cards.list',
        list_cards: 'operations.list_cards'
      ]

      def handle(req, res)
        case list_cards.()
        in Success(board)
          res.render view, board: board
        in Failure(:db, error)
          logger.error(error.message)
        in Failure(x)
          res.body = x.errors
        end
      end
    end
  end
end
