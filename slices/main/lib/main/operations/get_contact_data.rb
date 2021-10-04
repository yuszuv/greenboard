# frozen_string_literal: true

module Main
  module Operations
    class GetContactData < HanfBrett::Operation
      include Deps[
        repo: 'repositories.card',
      ]

      def call(id)
        # data = yield validate(id, params)
        card = yield get_card(id)

        Success(card.contact)
      end

      private

      def get_card(card_id)
        Try[ROM::TupleCountMismatchError] do
          repo.cards.by_pk(card_id).one!
        end.to_result.or do |x|
          Failure[:not_found, x]
        end
      end
    end
  end
end
