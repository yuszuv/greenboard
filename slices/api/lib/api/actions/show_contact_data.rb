# frozen_string_literal: true

module Api
  module Actions
    class ShowContactData < Main::Action
      include Deps[
        get_contact_data: 'operations.get_contact_data'
      ]

      def handle(req, res)
        case get_contact_data.(req.params[:id])
        in Success(contact_data)
          res.status = 200
          res.body = contact_data.to_json
        in Failure(:not_found)
          res.status = 404
        else
          res.status = 500
        end
      end
    end
  end
end

