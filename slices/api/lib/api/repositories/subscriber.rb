module Api
  module Repositories
    class Subscriber < Repository[:subscribers]
      commands :create

      def exists?(email)
        !subscribers
          .where(email: email)
          .to_a
          .empty?
      end
    end
  end
end
