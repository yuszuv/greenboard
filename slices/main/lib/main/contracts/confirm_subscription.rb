# frozen_string_literal: true

module Main
  module Contracts
    class ConfirmSubscription < HanfBrett::Validation::Contract
      params do
        required(:token).filled(:string)
      end
    end
  end
end
