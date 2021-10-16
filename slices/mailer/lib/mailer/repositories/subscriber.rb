module Mailer
  module Repositories
    class Subscriber < Repository[:subscribers]
      def find(email)
        !subscribers
          .where(email: email)
          .to_a
          .empty?
      end
    end
  end
end

