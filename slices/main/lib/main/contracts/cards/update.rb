# frozen_string_literal: true

module Main
  module Contracts
    module Cards
      class Update < HanfBrett::Validation::Contract
        params do
          optional(:type).filled(:string)
          optional(:topic).filled(:string)
          optional(:text).filled(:string)
          optional(:author).filled(:string)
          optional(:password).filled(:string)
        end

        rule :type do
          key.failure("must be one of 'BIETE', 'SUCHE'. was: #{value}") unless %w(SUCHE BIETE).include?(value)
        end
      end
    end
  end
end
