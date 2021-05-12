module Main
  module Repositories
    class Card < Repository[:cards]
      commands :create, update: :by_pk, delete: :by_pk

      def find(id)
        cards.by_pk(id).one
      end

      def board
        board = OpenStruct.new(requests: [], offers: [])
        cards
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
    end
  end
end
