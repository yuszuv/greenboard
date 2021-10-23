# frozen_string_literal: true

module Api
  module Contracts
    module Mailer
      class SubscribeUpdates < HanfBrett::Validation::Contract
        include Deps[
          repo: 'repositories.subscriber'
        ]

        json do
          required(:email).filled(:string)
          required(:tos).filled(:bool, :true?)
        end

        rule(:email) do
          key.failure("ist schon eingetragen") if repo.exists?(values[:email])
        end

        rule(:email) do
          unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
            key.failure(:format?)
          end
        end
      end
    end
  end
end



