# auto_register: false
# frozen_string_literal: true

require 'dry/monads'

require "hanf_brett/action"

module Api
  class Action < HanfBrett::Action
    include Dry::Monads[:result]

    accept :json

    def verify_csrf_token?
      false
    end
  end
end
