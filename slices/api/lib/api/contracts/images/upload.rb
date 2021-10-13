# frozen_string_literal: true

module Api
  module Contracts
    module Images
      class Upload < HanfBrett::Validation::Contract
        params do
          # TODO
          # required(:card_id).filled(:integer)
          required(:file).hash do
            required(:filename).filled
            required(:type).filled
            required(:tempfile).filled
          end
        end
      end
    end
  end
end


