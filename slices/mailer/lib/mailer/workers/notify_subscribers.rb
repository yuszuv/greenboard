# frozen_string_literal: true

require 'sidekiq'

require 'dry/effects'

module Mailer
  module Workers
    class NotifySubscribers < HanfBrett::Operation
      include Dry::Effects.CurrentTime
      include Sidekiq::Worker

      include Deps[
        mailer: 'application.mailer',
        logger: 'application.mail_logger',
        card_repo: 'repositories.card',
        subscriber_repo: 'repositories.subscriber',
        view: 'views.notify_subscriber'
      ]

      FROM = '[DEV] Gruenes Brett<no-reply@gruenesbrett.de'
      TO = 'j.paki@lpv-prignitz-ruppin.de'
      SUBJECT = 'HEADS UP!!! Neuer oder geänderter Eintrag auf dem "Grünen Brett"'

      def perform(card_id)
        case call(card_id)
        in Success(_)
          0
        end
      rescue NoMatchingPatternError => e
        raise e
      end


      def call(card_id)
        card = yield get_card(card_id)

        if !card.notification_sent_at
          recipients = yield get_subscribers
          card = yield add_timestamp(card, current_time)

          sent_to = recipients.map do |recipient|
            body = view.(subscriber: recipient, card: card).to_s
            mail = send_mail(body).or(&log_error)
            [recipient, mail]
          end
            .filter{ |_,r| r.success? }
            .map{ |v,_| v }

          Success(card: card, recipients: sent_to)
        else
          Failure(:notification_already_sent)
        end
      end

      private

      def get_card(id)
        Maybe(card_repo.find(id)).to_result(:not_found)
      end

      def get_subscribers
        Success(subscriber_repo.active_subscribers)
      end

      def add_timestamp(card, timestamp)
        Success(card_repo.update(card.id, notification_sent_at: timestamp))
      end

      def send_mail(body)
        Try[Errno::ECONNREFUSED] do
          mailer.(
            from: FROM,
            to: TO,
            subject: SUBJECT,
            body: body
          )
        end.to_result
      end

      def log_error
        # TODO: add monitoring
        Proc.new do |e|
          logger.(e)
          Failure(e)
        end
      end
    end
  end
end
