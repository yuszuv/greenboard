# frozen_string_literal: true

module Api
  module Contracts
    module Cards
      class Create < HanfBrett::Validation::Contract
        json do
          required(:type).filled(:string)
          required(:topic).filled(:string)
          required(:text).filled(:string)
          required(:contact).filled(:string)
          required(:password).filled(:string)
          required(:password_confirmation).filled(:string)
          optional(:images).array(:hash) do
            optional(:id).maybe(:integer)
            required(:image_data).filled(:hash)
          end

          required(:tos).filled(:bool, :true?)
        end

        rule(:password).validate(min_size?: 6)
        rule(:password, :password_confirmation) do
          key.failure('stimmt nicht mit Passwortbestätigung überein') unless values[:password] == values[:password_confirmation]
        end
        rule :type do
          list = %w(SUCHE BIETE)
          key.failure(:inclusion?, list: list) unless list.include?(value)
        end
      end
    end
  end
end
