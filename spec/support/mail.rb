# require_with_metadata: true
# frozen_string_literal: true

require 'mail'

Mail.defaults do
  delivery_method :test
end
