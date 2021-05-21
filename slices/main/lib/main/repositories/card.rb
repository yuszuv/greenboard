module Main
  module Repositories
    class Card < Repository[:cards]
      commands :create, update: :by_pk, delete: :by_pk

      def find(id)
        cards
          .combine(:photos)
          .by_pk(id)
          .one
      end

      def board
        board = OpenStruct.new(requests: [], offers: [])
        cards
          .combine(:photos)
          .order(Sequel.desc(:created_at))
          .to_a
          .each_with_object(board) do |card, b|
            case card.type
            when 'SUCHE' then b.requests.push(card)
            when 'BIETE' then b.offers.push(card)
            end
            b
          end

        board
      end

      def create_with_photos(data)
        cards.combine(:photos).command(:create).(data)
      end

      def update_with_photos(id, data)
        cards.transaction do
          card = cards.by_pk(id).changeset(:update, **data).commit

          data[:photos].map do |i|
            if i[:id]
              unless i[:_remove] == true
                photos
                  .by_pk(i[:id])
                  .changeset(:update, **i)
                  .associate(card)
                  .commit
              else
                photo.command(:delete).(i[:id])
              end
            else
              photos.changeset(:create, **i).associate(card).commit
            end
          end

          card
        end
      end

      def delete_with_photos(id)
        cards.transaction do
          cards.photos.where(card_id: id).delete
          cards.by_pk(id).delete
        end
      end
    end
  end
end
