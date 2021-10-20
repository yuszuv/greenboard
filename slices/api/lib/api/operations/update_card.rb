# frozen_string_literal: true

module Api
  module Operations
    class UpdateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.update',
        repo: 'repositories.card',
        mailer: 'application.mailer',
        notify_admin: 'mailer.workers.notify_admin'
      ]

      def call(**input)
        (yield validate(input).fmap(&:to_h)) => { id:, current_password:, **data }

        yield authorize(id, current_password)
        card = yield persist(id: id, **data.to_h)

        yield notify_admin.(card.id)

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

      def authorize(id, password)
        Try[ROM::SQL::Error] { repo.find(id) }
          .to_result.bind do |card|
            card.password == encrypt_password(password) ?
              Success() :
              Failure[:authorization, { password: ['Das Passwort stimmt nicht'] }]
          end
      end

      def persist(**data)
        data => { id:, **attrs }

        password = attrs[:password]

        Try[ROM::SQL::Error, ROM::SQL::NotNullConstraintError] do
          data.merge!(password: encrypt_password(password)) if password

          repo.update_with_images(id, data)
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
