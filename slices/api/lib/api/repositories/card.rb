module Api
  module Repositories
    class Card < Repository[:cards]
      def find_with_images(id)
        cards
          .combine(:images)
          .by_pk(id)
          .one!
      end

      def create_with_images(data)
        cards.combine(:images).command(:create).(data)
      end

      def update_with_images(id, data)
        cards.transaction do
          card = cards.by_pk(id).changeset(:update, **data).commit

          existing_ids = cards.combine(:images).by_pk(id).one.images.map(&:id)
          image_ids = data[:images].map{ _1[:id] }

          (existing_ids - image_ids).each do |id|
            images.by_pk(id).changeset(:delete).commit
          end

          data[:images].each do |i|
            if i[:id]
              images
                .by_pk(i[:id])
                .changeset(:update, **i)
                .associate(card)
                .commit
            else
              images
                .changeset(:create, **i)
                .associate(card)
                .commit
            end
          end

          card
        end
      end

      # def delete_with_images(id)
      #   cards.transaction do
      #     cards.images.where(card_id: id).delete
      #     cards.by_pk(id).delete
      #   end
      # end
    end
  end
end
