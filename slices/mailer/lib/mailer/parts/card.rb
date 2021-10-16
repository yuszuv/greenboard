require 'hanami/view'

module Mailer
  module Parts
    class Card < Hanami::View::Part
      def card_url
        "http://TODO with dir-effects"
      end

      def unsubscribe_url
        "https://TODO"
      end
    end
  end
end
