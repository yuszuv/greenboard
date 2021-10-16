# frozen_string_literal: true

require "hanami/view"
require_relative "parts"

module Mailer
  class View < Hanami::View
    # This will eventually be automatic via Hanami 2 view integration
    config.inflector = Hanami.application[:inflector]
    config.paths = [File.join(__dir__, "../../templates")]
    config.default_format = :txt
    config.layout = 'text_mail'
    config.default_context = Context.new

    config.part_namespace = Parts
  end
end
