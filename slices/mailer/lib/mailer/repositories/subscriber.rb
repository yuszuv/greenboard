module Mailer
  module Repositories
    class Subscriber < Repository[:subscribers]
      def find(email)
        !subscribers
          .where(email: email)
          .to_a
          .empty?
      end

      def active_subscribers
        subscribers
          .where(Sequel.~(confirmed_at: nil))
          .to_a
      end
    end
  end
end

