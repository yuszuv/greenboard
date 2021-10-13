# frozen_string_literal: true

module Api
  module Operations
    class CreateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.create',
        repo: 'repositories.card',
        mailer: 'application.mailer'
      ]

      def call(input)
        data = yield validate(input)
        res = yield persist(data.to_h)
        # TODO: add another mailer slice
        # notify_admin(res)

        Success(res)
      end

      private

      def notify_admin(res)
        mailer.(res.text)
      end

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
