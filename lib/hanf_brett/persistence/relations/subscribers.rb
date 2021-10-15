module Persistence
  module Relations
    class Subscribers < ROM::Relation[:sql]
      schema(:subscribers, infer: true)
    end
  end
end
