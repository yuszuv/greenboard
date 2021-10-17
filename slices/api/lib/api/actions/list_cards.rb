# frozen_string_literal: true

module Api
  module Actions
    class ListCards < Api::Action
      include Deps[
        'operations.list_cards'
      ]

      def handle(req, res)
        case list_cards.()
        in Success(*board)
          res.status = 200
          res.body = board.map(&:to_h).to_json
        in Failure(:db | :storage, error)
          logger.error(error.inspect)
          res.status = 500
          res.body = "server error"
        end
      end
    end
  end
end

