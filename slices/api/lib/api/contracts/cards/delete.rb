# frozen_string_literal: true

module Api
  module Contracts
    module Cards
      class Delete < HanfBrett::Validation::Contract
        json do
          required(:id).filled(:string)
          required(:password).filled(:string)
        end
      end
    end
  end
end
