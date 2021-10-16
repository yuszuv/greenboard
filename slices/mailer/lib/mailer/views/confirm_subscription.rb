# frozen_string_literal: true

require 'dry/effects'

module Mailer
  module Views
    class ConfirmSubscription < Mailer::View
      expose :subscriber
    end
  end
end

