module Mailer
  module Repositories
    class Subscriber < Repository[:subscribers]
      def active_subscribers
        subscribers
          .where(Sequel.~(confirmed_at: nil))
          .to_a
      end
    end
  end
end

