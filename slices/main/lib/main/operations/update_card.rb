# frozen_string_literal: true

module Main
  module Operations
    class UpdateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.update',
        repo: 'repositories.card'
      ]

      def call(id:, **params)
        data = yield validate(params)
        yield authorize(id, data)
        card = yield update_record(id, data)

        Success(card)
      end

      private

      def validate(input)
        contract.(input).to_monad.or do |x|
          Failure[
            :validation,
            Entities::CardForm.new(id: nil, **input),
            x.errors(full: true).to_h.values.flatten
          ]
        end.fmap do |result|
          result.to_h
        end
      end

      def update_record(id, data)
        data
          .merge(password: encrypt_password(data[:password]))
          .then do |d|
            Try[ROM::SQL::Error] do
              repo.update(id, d)
            end.to_result.or do |x|
              Failure[:db, x]
            end
          end
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end

      def authorize(id, data)
        Try[ROM::SQL::Error] do
          repo.find(id)
        end.to_result.bind do |card|
          card.password == encrypt_password(data[:password]) ? Success() : Failure[:authorization, data, ['Das Passwort stimmt nicht']]
        end
      end
    end
  end
end
