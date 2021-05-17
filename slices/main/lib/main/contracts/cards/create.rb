# frozen_string_literal: true

module Main
  module Contracts
    module Cards
      class Create < HanfBrett::Validation::Contract
        option :attacher, default: proc { HanfBrett::ImageUploader::Attacher.new }

        params do
          required(:type).filled(:string)
          required(:topic).filled(:string)
          required(:text).filled(:string)
          required(:author).filled(:string)
          required(:password).filled(:string)
          optional(:image).maybe(:hash)
        end

        rule :image do |context:|
          context[:attacher] ||= attacher

          if value
            attacher = HanfBrett::ImageUploader::Attacher.new(file: value)
            # attacher.form_assign(value)
            attacher.assign(value)
            require 'byebug'
            byebug
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
