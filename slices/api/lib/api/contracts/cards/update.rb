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
          required(:current_password).filled(:string)
          optional(:password).filled(:string, min_size?: 6)
          optional(:password_confirmation).filled(:string)
          optional(:images).array(:hash) do
            optional(:id).maybe(:integer)
            required(:image_data).filled(:hash)
          end

          required(:tos).filled(:bool, :true?)
        end

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
