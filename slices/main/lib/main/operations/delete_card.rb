# frozen_string_literal: true

module Main
  module Operations
    class DeleteCard < HanfBrett::Operation
      include Deps[repo: 'repositories.card']

      def call(id:, password:, **params)
        yield authorize(id, password, params)
        card = yield persist(id)

        Success(card)
      end

      private

      def authorize(id, password, data)
        Try[ROM::SQL::Error] do
          repo.find(id)
        end.to_result.bind do |card|
          card.password == encrypt_password(password) ?
            Success() :
            Failure[:authorization, id, ['Das Passwort stimmt nicht']]
        end
      end

      def persist(id)
        Try[ROM::SQL::Error] do
          repo.delete_with_photos(id)
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
