module Persistence
  module Relations
    class Photos < ROM::Relation[:sql]
      schema(:photos, infer: true) do
        associations do
          belongs_to :card
        end
      end
    end
  end
end

