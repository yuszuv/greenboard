# frozen_string_literal: true

module Api
  module Contracts
    module Cards
      class Create < HanfBrett::Validation::Contract
        json do
          required(:type).filled(HanfBrett::Types::CardType)
          required(:topic).filled(:string)
          required(:text).filled(:string)
          required(:contact).filled(:string)
          required(:password).filled(HanfBrett::Types::CardPassword)
          required(:password_confirmation).filled(:string)
          required(:images).array(:hash) do
            optional(:id).maybe(:integer)
            required(:image_data).filled(:hash)
          end

          required(:tos).filled(:bool, :true?)
        end

        rule(:password, :password_confirmation) do
          key.failure('stimmt nicht mit Passwortbestätigung überein') unless values[:password] == values[:password_confirmation]
        end
      end
    end
  end
end
