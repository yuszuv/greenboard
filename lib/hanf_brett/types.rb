# auto_register: false
# frozen_string_literal: true

require "dry/types"

module HanfBrett
  module Types
    include Dry.Types

    CardType = String.enum('SUCHE', 'BIETE')
    CardPassword = String.constrained(min_size: 6)
  end
end
