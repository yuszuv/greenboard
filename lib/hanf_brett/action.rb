# auto_register: false
# frozen_string_literal: true

require "json" # required for Hanami::Action::Flash to work
require "hanami/action"
require "hanami/action/cookies"
require "hanami/action/csrf_protection"
require "hanami/action/session"

module HanfBrett
  class Action < Hanami::Action
  end
end
