# auto_register: false

module Frontend
  module Entities
  end
end

Dir[File.join(__dir__, "entities", "*.rb")].each(&method(:require))
