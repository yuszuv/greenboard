# frozen_string_literal: true

module Main
  module Operations
    class ConfirmSubscription < HanfBrett::Operation
      include Deps[
        repo: 'repositories.subscriber',
        contract: 'contracts.confirm_subscription'
      ]

      def call(input)
        data = yield validate(input)
        subscription = yield confirm(data[:token])

        Success(subscription)
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

      def confirm(token)
        Maybe(repo.find_by_confirmation_token(token)).to_result(:not_found)
      end
    end
  end
end

