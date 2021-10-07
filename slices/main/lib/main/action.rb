# auto_register: false
# frozen_string_literal: true

require 'dry/monads'

require "hanf_brett/action"

module Main
  class Action < HanfBrett::Action
    include Dry::Monads[:result]

    def self.inherited(klass)
      super

      # These will need to be sorted by the framework eventually
      klass.include Hanami::Action::Cookies
      klass.include Hanami::Action::Session
      klass.include Hanami::Action::CsrfProtection
    end
  end
end
