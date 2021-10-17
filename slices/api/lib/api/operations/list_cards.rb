# frozen_string_literal: true

module Api
  module Operations
    class ListCards < HanfBrett::Operation
      include Deps[
        repo: 'repositories.card',
        board_mapper: 'mappers.board'
      ]

      def call
        board = yield fetch_public_cards

        Success(board)
      end

      private

      def fetch_public_cards
        Try[ROM::SQL::Error] { repo.public_cards }
          .fmap { |cards| board_mapper.(cards) }
          .to_result
      end
    end
  end
end
