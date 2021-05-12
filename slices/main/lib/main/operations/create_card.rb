# frozen_string_literal: true

module Main
  module Operations
    class CreateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.create',
        repo: 'repositories.card'
      ]

      def call(input)
        data = yield validate(input)
        res = yield create_record(data)

        Success(res)
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

      def create_record(data)
        Try[ROM::SQL::Error] {
          repo.create(encrypt_password(data))
        }.to_result.or do |x|
          Failure[:db, x]
        end
      end

      def encrypt_password(data)
        HanfBrett::Functions[
          :map_value,
          :password,
          -> s { HanfBrett::Functions[:encrypt_password].(s) }
        ].(data)
      end
    end
  end
end
