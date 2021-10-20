# frozen_string_literal: true

module Api
  module Contracts
    module Cards
      class Update < HanfBrett::Validation::Contract
        json do
          required(:id).filled(:string)
          required(:current_password).filled(:string)

          required(:type).filled(HanfBrett::Types::CardType)
          optional(:topic).filled(:string)
          optional(:text).filled(:string)
          optional(:contact).filled(:string)
          required(:password).filled(HanfBrett::Types::CardPassword)
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
      end
    end
  end
end
