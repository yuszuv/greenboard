# frozen_string_literal: true

module Mailer
  module Views
    class ConfirmSubscription < Mailer::View
      expose :subscriber
    end
  end
end

