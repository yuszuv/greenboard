# auto_register: false
# frozen_string_literal: true

require "dry/monads"
require "dry/matcher/result_matcher"

module HanfBrett
  class Operation
    include Dry::Monads[:result, :try, :maybe]

    class << self
      def inherited(klass)
        klass.include Dry::Monads[:do]
      end
    end
  end
end
