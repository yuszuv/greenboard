module Persistence
  module Relations
    class Cards < ROM::Relation[:sql]
      schema(:cards, infer: true) do
        associations do
          has_many :images
        end
      end

      def with_images
        # cards.where(id: images.order.distinct.select(:card_id).query)
        cards.where(Sequel.lit('id in ?', images.order.distinct.select(:card_id).query))
      end

      def without_images
        cards.exclude(Sequel.lit('id in ?', images.order.distinct.select(:card_id).query))
      end
    end
  end
end
