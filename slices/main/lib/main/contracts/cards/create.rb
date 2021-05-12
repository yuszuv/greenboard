# frozen_string_literal: true

module Main
  module Contracts
    module Cards
      class Create < HanfBrett::Validation::Contract
        params do
          required(:type).filled(:string)
          required(:topic).filled(:string)
          required(:text).filled(:string)
          required(:author).filled(:string)
          required(:password).filled(:string)
        end

        rule :type do
          key.failure("must be one of 'BIETE', 'SUCHE'. was: #{value}") unless %w(SUCHE BIETE).include?(value)
        end
      end
    end
  end
end
