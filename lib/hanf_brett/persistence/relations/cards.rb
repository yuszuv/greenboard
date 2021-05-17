module Persistence
  module Relations
    class Cards < ROM::Relation[:sql]
      schema(:cards, infer: true) do
        associations do
          has_many :photos
        end
      end
    end
  end
end
