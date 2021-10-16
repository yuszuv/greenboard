# frozen_string_literal: true

module Frontend
  module Views
    class ConfirmSubscription < View::Base
      expose :unsubscribe_url do |subscriber:|
        "/abonnement_loeschen?token=%s" % [
          subscriber.confirmation_token
        ]
      end
    end
  end
end
