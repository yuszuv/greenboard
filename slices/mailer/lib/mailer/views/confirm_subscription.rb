# frozen_string_literal: true

module Mailer
  module Views
    class ConfirmSubscription < Mailer::View
      expose :subscriber
      expose :confirmation_url do |host:, subscriber:|
        "%s/abonnement_bestaetigen?token=%s" % [
          host,
          subscriber.confirmation_token
        ]
      end
    end
  end
end

