# frozen_string_literal: true

module Main
  module Actions
    class ShowContactData < Main::Action
      include Deps[
        get_contact_data: 'operations.get_contact_data'
      ]

      accept :json

      def handle(req, res)
        # case list_cards.()
        # in Success(board)
        #   res.render view, board: board
        # in Failure(:db, error)
        #   logger.error(error.message)
        # in Failure(x)
        #   res.body = x.errors
        # end
        case get_contact_data.(req.params[:id])
        in Success(contact_data)
          res.status = 200
          res.body = contact_data.to_json
        in Failure[:not_found, x]
          res.status = 404
          res.body = nil
        else
          res.status = 501
          res.body = ""
        end
      end
    end
  end
end

