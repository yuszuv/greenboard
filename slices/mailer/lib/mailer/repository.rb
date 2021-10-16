# frozen_string_literal: true

require "hanf_brett/repository"
# require_relative "entities"

module Mailer
  class Repository < HanfBrett::Repository
    struct_namespace Entities
  end
end
