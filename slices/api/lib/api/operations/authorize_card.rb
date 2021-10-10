# frozen_string_literal: true

module Api
  module Operations
    class AuthorizeCard < HanfBrett::Operation
      include Deps[
        repo: 'repositories.card'
      ]

      def call(id, password)
        card = yield get_card(id)
        res = yield authorize(card, password)

        Success(res)
      end

      private

      def get_card(id)
        Try[ROM::TupleCountMismatchError] do
          repo.find(id)
        end.or do |e|
          Failure(:not_found)
        end
      end

      def authorize(card, password)
        (card.password == encrypt_password(password)) ?
          Success() :
          Failure(:unauthorized)
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end
    end
  end
end
