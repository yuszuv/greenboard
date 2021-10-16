require 'hanami/view'

module Mailer
  module Parts
    class Subscriber < Hanami::View::Part
      include Dry::Effects.Resolve(:host)

      def confirmation_url
        "%s/abonnement_bestaetigen?token=%s" % [
          host.to_s,
          confirmation_token
        ]
      end

      def unsubscribe_url
        "%s/abonnement_loeschen?token=%s" % [
          host.to_s,
          confirmation_token
        ]
      end
    end
  end
end
