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

    def self.reduce_array(array, acc, fn)
      array.reduce(acc, &fn)
    end

    def self.transform_object(obj, fn)
      fn[obj]
    end

    def self.to_hash(obj)
      obj.to_h
    end
  end
end
