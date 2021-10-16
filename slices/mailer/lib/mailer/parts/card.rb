require 'hanami/view'

module Mailer
  module Parts
    class Card < Hanami::View::Part
      include Dry::Effects.Resolve(:host)

      def url
        "%s/eintraege/%s" % [
          host.to_s,
          id
        ]
      end
    end
  end
end
