module Persistence
  module Relations
    class Images < ROM::Relation[:sql]
      schema(:images, infer: true) do
        associations do
          belongs_to :card
        end
      end
    end
  end
end

