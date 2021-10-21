# frozen_string_literal: true

module Mailer
  module Operations
    class NotifySubscribers < HanfBrett::Operation
      def call(card, timestamp)
        Success(Workers::NotifySubscribers.perform_at(timestamp, card.id))
      end
    end
  end
end

