# frozen_string_literal: true

module Api
  module Operations
    class SubscribeUpdates < HanfBrett::Operation
      include Deps[
        logger: 'application.mail_logger',
        repo: 'repositories.subscriber',
        contract: 'contracts.mailer.subscribe_updates',
        confirmation_mailer: 'mailer.operations.request_confirmation'
      ]

      MINIMUM_TOKEN_LENGTH = 24

      def call(input, request)
        data = yield validate(input)
        subscriber = yield persist(data[:email])
        mail = yield send_confirmation_mail(subscriber, request)

        Success(mail)
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

      def persist(email)
        Try[ROM::SQL::Error] do
          repo.create(
            email: email,
            confirmation_token: generate_unique_secure_token
          )
        end
      end

      def send_confirmation_mail(rec, request)
        confirmation_mailer.(rec, request)
      end

      def generate_unique_secure_token(length: MINIMUM_TOKEN_LENGTH)
        SecureRandom.hex(length)
      end
    end
  end
end
