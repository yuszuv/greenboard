require 'hanami/view'

module Mailer
  module Parts
    class Subscriber < Hanami::View::Part
      def confirmation_url
        confirmation_token
      end

      def unsubscribe_url
        confirmation_token
      end
    end
  end
end
