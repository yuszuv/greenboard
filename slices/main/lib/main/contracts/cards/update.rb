# frozen_string_literal: true

module Main
  module Contracts
    module Cards
      class Update < HanfBrett::Validation::Contract
        option :attacher, default: proc { HanfBrett::ImageUploader::Attacher.new }

        params do
          optional(:type).filled(:string)
          optional(:topic).filled(:string)
          optional(:text).filled(:string)
          optional(:author).filled(:string)
          optional(:password).filled(:string)

          optional(:image).filled
        end

        rule :image do |context:|
          context[:attacher] ||= attacher
        end

        rule :type do
          key.failure("must be one of 'BIETE', 'SUCHE'. was: #{value}") unless %w(SUCHE BIETE).include?(value)
        end
      end
    end
  end
end
