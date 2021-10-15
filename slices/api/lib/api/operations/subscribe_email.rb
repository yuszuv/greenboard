# frozen_string_literal: true

module Api
  module Operations
    class SubscribeEmail < HanfBrett::Operation
      include Deps[
        repo: 'repositories.subscriber',
        contract: 'contracts.mailer.subscribe_updates'
      ]

      MINIMUM_TOKEN_LENGTH = 24

      def call(input)
        data = yield validate(input)
        rec = yield persist(data[:email])
        # yield send_mail

        Success(rec)
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

      def generate_unique_secure_token(length: MINIMUM_TOKEN_LENGTH)
        SecureRandom.hex(length)
      end

      def get_card(id)
        Try[ROM::TupleCountMismatchError] do
          repo.find_with_images(id)
        end.or do |e|
          Failure(:not_found)
        end
      end
    end
  end
end
