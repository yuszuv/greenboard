module Persistence
  module Relations
    class Cards < ROM::Relation[:sql]
      schema(:cards, infer: true)
    end
  end
end
