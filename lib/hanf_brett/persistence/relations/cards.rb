module Persistence
  module Relations
    class Cards < ROM::Relation[:sql]
      schema(:cards, infer: true) do
        associations do
          has_many :images
        end
      end
    end
  end
end
