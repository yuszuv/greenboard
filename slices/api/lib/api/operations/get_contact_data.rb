# frozen_string_literal: true

module Api
  module Operations
    class GetContactData < HanfBrett::Operation
      include Deps[
        repo: 'repositories.card',
      ]

      def call(id)
        card = yield get_card(id)

        Success(card.contact)
      end

      private

      def get_card(card_id)
        Try[ROM::TupleCountMismatchError] do
          repo.find(card_id)
        end.to_result.or do |x|
          Failure(:not_found)
        end
      end
    end
  end
end
