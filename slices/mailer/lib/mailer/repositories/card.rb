module Mailer
  module Repositories
    class Card < Repository[:cards]
      commands update: :by_pk

      def find(id)
        cards.by_pk(id).one!
      rescue ROM::TupleCountMismatchError
        nil
      end
    end
  end
end

