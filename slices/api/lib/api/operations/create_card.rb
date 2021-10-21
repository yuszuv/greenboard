# frozen_string_literal: true

require 'dry/effects'

module Api
  module Operations
    class CreateCard < HanfBrett::Operation
      include Dry::Effects.CurrentTime

      include Deps[
        contract: 'contracts.cards.create',
        repo: 'repositories.card',
        notify_subscribers: 'mailer.operations.notify_subscribers',
        notify_admin: 'mailer.operations.notify_admin'
      ]

      def call(input)
        send_at = current_time + 60 * 60

        data = yield validate(input)
        card = yield persist(**data.to_h)
        yield notify_admin.(card)
        yield notify_subscribers.(card, send_at)

        Success(card)
      end

      private

      def validate(input)
        contract.(input)
          .to_monad
          .or do |result|
            Failure[
              :validation,
              result.errors(full: true).to_h
            ]
          end
      end

      def persist(**data)
        Try[ROM::SQL::Error] do
          data
            .merge(password: encrypt_password(data[:password]))
            .then(&repo.method(:create_with_images))
        end.to_result.or do |x|
          Failure[:db, x]
        end
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end
    end
  end
end
