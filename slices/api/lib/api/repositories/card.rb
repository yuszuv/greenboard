module Api
  module Repositories
    class Card < Repository[:cards]
      def find(id)
        cards.by_pk(id).one!
      end

      def delete_with_images(id)
        cards.transaction do
          cards.images.where(card_id: id).delete
          cards.by_pk(id).delete
        end
      end

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

          existing_image_ids = cards.combine(:images).by_pk(id).one.images.map(&:id)

          images_data = data[:images].to_a
          image_ids = images_data.map{ _1[:id] }

          (existing_image_ids - image_ids).each do |id|
            images.by_pk(id).changeset(:delete).commit
          end

          images_data.each do |i|
            if id = i[:id]
              images
                .by_pk(id)
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

      def public_cards
        cards
          .combine(:images)
          .order(Sequel.desc(:updated_at))
          .to_a
      end

    end
  end
end
