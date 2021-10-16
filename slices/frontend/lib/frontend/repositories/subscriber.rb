module Frontend
  module Repositories
    class Subscriber < Repository[:subscribers]
      commands delete: :by_pk

      def find_by_confirmation_token(token)
        subscribers
          .where(confirmation_token: token)
          .to_a
          .first
      end

      def confirm!(subscriber_id)
        subscribers
          .by_pk(subscriber_id)
          .changeset(:update, confirmed_at: Time.now)
          .commit
      end
    end
  end
end
