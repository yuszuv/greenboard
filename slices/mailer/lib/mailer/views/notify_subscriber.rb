# frozen_string_literal: true

module Mailer
  module Views
    class NotifySubscriber < Mailer::View
      expose :card
      expose :subscriber
    end
  end
end

