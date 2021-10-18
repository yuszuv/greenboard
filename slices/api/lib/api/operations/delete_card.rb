# frozen_string_literal: true

module Api
  module Operations
    class DeleteCard < HanfBrett::Operation
      include Dry::Monads[:maybe]

      include Deps[
        contract: 'contracts.cards.delete',
        authorize_card: 'operations.authorize_card',
        repo: 'repositories.card'
      ]

      def call(input)
        data = yield validate(input)
        yield authorize_card.(data[:id], data[:password])
        res = yield delete_card(data[:id])

        Success(res)
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

      def delete_card(id)
        Maybe(repo.delete_with_images(id)).to_result(:not_found)
      end
    end
  end
end
