# frozen_string_literal: true

module Api
  module Mailers
    class NotifyCreate < HanfBrett::Mailer
      def call(card)
        card
          .then(&method(:email_body))
          .then(&method(:generate_email))
          .deliver!
      end

      private

      def email_body(card)
        card.text
      end

      def generate_email(body)
        mail = Mail.new do
          from     "[DEV] Gruenes Brett<no-reply@gruenesbrett.de"
          to       'jan@sternprodukt.de'
          subject  'Neuer Eintrag auf dem "Grünen Brett"'
          body     body
        end
      end
    end
  end
end
