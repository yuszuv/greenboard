module Main
  module Repositories
    class Subscriber < Repository[:subscribers]
      def find_by_confirmation_token(token)
        subscribers
          .where(confirmation_token: token)
          .to_a
          .first
      end
    end
  end
end
