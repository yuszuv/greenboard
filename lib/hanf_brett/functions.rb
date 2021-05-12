# auto_register: false
# frozen_string_literal: true

require "transproc"
require "digest"

module HanfBrett
  module Functions
    extend Transproc::Registry

    import Transproc::HashTransformations
    import Transproc::ArrayTransformations

    def self.encrypt_password(str)
      Digest::SHA256.hexdigest(str)
    end
  end
end
