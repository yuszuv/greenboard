# frozen_string_literal: true

module Api
  module Operations
    class GetCard < HanfBrett::Operation
      include Deps[
        repo: 'repositories.card',
      ]

      def call(id)
        res = yield get_card(id)

        Success(res)
      end

      private

      def get_card(id)
        Try[ROM::TupleCountMismatchError] do
          repo.find_with_images(id)
        end.or do |e|
          Failure(:not_found)
        end
      end
    end
  end
end
