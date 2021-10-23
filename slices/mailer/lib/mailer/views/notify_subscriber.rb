# frozen_string_literal: true

require 'base64'

module Mailer
  module Views
    class NotifySubscriber < Mailer::View
      expose :card
      expose :subscriber
    end
  end
end

