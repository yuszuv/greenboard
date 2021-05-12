# frozen_string_literal: true

module Main
  module Actions
    class BuildCard < Main::Action
      include Deps[
        view: 'views.cards.form'
      ]

      def handle(req, res)
        res.render view, form: Entities::CardForm.empty, errors: []
      end
    end
  end
end
