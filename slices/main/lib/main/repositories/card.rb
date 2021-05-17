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
    end
  end
end
