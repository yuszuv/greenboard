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
          optional(:image).maybe(:hash)
          required(:tos).filled(:bool, :true?)
        end

        rule(:password).validate(min_size?: 6)

        rule :image do |context:|
          attacher = HanfBrett::ImageUploader::Attacher.new
          context[:attacher] = attacher

          if value
            # attacher.form_assign(value)
            attacher.assign(value)
            key.failure(attacher.errors.join("; ")) unless attacher.validate
          end
        end

        rule :type do
          list = %w(SUCHE BIETE)
          key.failure(:inclusion?, list: list) unless list.include?(value)
        end
      end
    end
  end
end
