# frozen_string_literal: true

module Mailer
  module Operations
    class NotifyAdmin < HanfBrett::Operation
      def call(card)
        Success(Workers::NotifyAdmin.perform_async(card.id))
      end
    end
  end
end
