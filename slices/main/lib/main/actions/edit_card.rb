# frozen_string_literal: true

module Main
  module Actions
    class EditCard < Main::Action
      include Deps[
        view: 'views.cards.form',
        get_form: 'operations.fetch_form_data'

      ]

      def handle(req, res)
        case get_form.(req.params.get(:id))
        in Success(form)
          res.render view, form: form, errors: []
        end
      end
    end
  end
end
