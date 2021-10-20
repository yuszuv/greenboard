module Mailer
  module Repositories
    class Card < Repository[:cards]
      def find(id)
        cards.by_pk(id).one!
      rescue ROM::TupleCountMismatchError
        nil
      end
    end
  end
end

