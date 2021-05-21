# frozen_string_literal: true

module Main
  module Actions
    class ConfirmDeleteCard < Main::Action
      include Deps[
        view: 'views.cards.confirm_delete',
      ]

      def handle(req, res)
        res.render view, id: req.params.get(:id), errors: []
      end
    end
  end
end
