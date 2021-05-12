# auto_register: false
# frozen_string_literal: true

require 'dry/monads'

require "hanf_brett/action"

module Main
  class Action < HanfBrett::Action
    include Dry::Monads[:result]
  end
end
