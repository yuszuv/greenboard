# frozen_string_literal: true

module Api
  module Operations
    class UpdateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.update',
        repo: 'repositories.card',
        mailer: 'application.mailer'
      ]

      def call(id:, **params)
        data = yield validate(params)
        yield authorize(id, data[:current_password])
        card = yield persist(id, data.to_h)
        # notify_admin(card)

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

      def authorize(id, password)
        Try[ROM::SQL::Error] { repo.find(id) }
          .to_result.bind do |card|
            card.password == encrypt_password(password) ?
              Success() :
              Failure[:authorization, { password: ['Das Passwort stimmt nicht'] }]
          end
      end

      def persist(id, **data)
        Try[ROM::SQL::Error, ROM::SQL::NotNullConstraintError] do
          data.merge!(password: encrypt_password(data[:password])) if data[:password]

          repo.update_with_images(id.to_i, data)
        end.to_result.or do |x|
          Failure[:db, x]
        end
      end

      def encrypt_password(str)
        return if str.nil?

        HanfBrett::Functions[:encrypt_password].(str)
      end
    end
  end
end
