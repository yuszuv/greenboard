# frozen_string_literal: true

module Main
  module Actions
    class EditCard < Main::Action
      include Deps[
        view: 'views.cards.form',
        get_form: 'operations.fetch_form_data'
      ]

      def handle(req, res)
        res.render view, id: req.params[:id]
      end
    end
  end
end
