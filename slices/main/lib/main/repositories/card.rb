module Main
  module Repositories
    class Card < Repository[:cards]
      def board
        board = OpenStruct.new(requests: [], offers: [])
        cards
          .combine(:images)
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
