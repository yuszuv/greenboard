# auto_register: false
# frozen_string_literal: true

require "dry/validation"
require "dry/schema/messages/i18n"

Dry::Validation.load_extensions(:monads)
Dry::Validation.load_extensions(:predicates_as_macros)

module HanfBrett
  module Validation
    class Contract < Dry::Validation::Contract
      config.messages.backend = :i18n
      config.messages.default_locale = :de
      config.messages.load_paths << 'config/locales/de.yml'
      config.messages.top_namespace = "validation"

      import_predicates_as_macros
    end
  end
end
