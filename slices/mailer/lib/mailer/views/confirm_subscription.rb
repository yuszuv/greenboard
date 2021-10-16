# frozen_string_literal: true

require 'dry/effects'

module Mailer
  module Views
    class ConfirmSubscription < Mailer::View
      include Dry::Effects.Resolve(:host)

      expose :subscriber
      expose :confirmation_url do |subscriber:|
        "%s/abonnement_bestaetigen?token=%s" % [
          host.to_s,
          subscriber.confirmation_token
        ]
      end
    end
  end
end

