# frozen_string_literal: true

module Api
  module Contracts
    module Cards
      class Update < HanfBrett::Validation::Contract
        json do
          optional(:type).filled(:string)
          optional(:topic).filled(:string)
          optional(:text).filled(:string)
          optional(:contact).filled(:string)
          optional(:password).filled(:string)
          optional(:images).array(:hash) do
            optional(:id).maybe(:integer)
            required(:image_data).filled(:string)
          end

          required(:tos).filled(:bool, :true?)
        end

        rule(:images).each do |index:|
          key([:images, index]).failure('images data is not valid') unless (!!JSON.parse(value[:image_data]) rescue false)
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
