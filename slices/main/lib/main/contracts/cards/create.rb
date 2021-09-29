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
          required(:images).array(:str?)
          required(:tos).filled(:bool, :true?)
        end

        rule(:images).each do |index:|
          key([:images, index]).failure('images data is not valid') unless (!!JSON.parse(value) rescue false)
        end
        rule(:password).validate(min_size?: 6)
        rule :type do
          list = %w(SUCHE BIETE)
          key.failure(:inclusion?, list: list) unless list.include?(value)
        end
      end
    end
  end
end
