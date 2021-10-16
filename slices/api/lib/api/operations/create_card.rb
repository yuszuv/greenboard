# frozen_string_literal: true

module Api
  module Operations
    class CreateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.create',
        repo: 'repositories.card',
        notify_subscribers: 'mailer.operations.notify_subscribers'
      ]

      def call(input)
        data = yield validate(input)
        card = yield persist(**data.to_h)
        # TODO: add another mailer slice
        yield notify_subscribers.(card)

        Success(card)
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
