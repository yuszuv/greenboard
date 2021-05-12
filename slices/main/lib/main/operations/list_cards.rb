# frozen_string_literal: true

module Main
  module Operations
    class ListCards < HanfBrett::Operation
      include Deps[repo: 'repositories.card']

      def call()
        board = yield fetch_board

        Success(board)
      end

      private

      def fetch_board
        Try[ROM::SQL::Error] do
          repo.board
        end.to_result.or do |x|
          Failure[:db, x]
        end
      end
    end
  end
end

