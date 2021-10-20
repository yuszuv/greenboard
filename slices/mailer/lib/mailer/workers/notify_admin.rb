# frozen_string_literal: true

require 'sidekiq'

module Mailer
  module Workers
    class NotifyAdmin < HanfBrett::Operation
      include Sidekiq::Worker

      include Deps[
        mailer: 'application.mailer',
        logger: 'application.mail_logger',
        repo: 'repositories.card',
        view: 'views.notify_admin'
      ]

      def perform(card_id)
        # TODO: add monitoring
        case call(card_id)
        in Success(_)
          0
        # in Failure(:not_found)
        #   puts "bar" * 2
        #   raise "🦄" * 100

        # in Failure(Exception, stacktrace)
        # trigger monitoring stuff
        # else
        # do something else
        end
      rescue NoMatchingPatternError => e
        raise e
      end

      def call(card_id)
        card = yield get_card(card_id)
        body = view.(card: card).to_s
        mail = yield send_mail(body)
        yield log_mail(mail)

        # case Failure(Exception)
        Success(mail)
      end

      private

      def get_card(id)
        Maybe(repo.find(id)).to_result(:not_found)
      end

      def send_mail(body)
        Try[Errno::ECONNREFUSED] do
          mail = mailer.(
            from: '[DEV] Gruenes Brett<no-reply@gruenesbrett.de',
            to: 'j.paki@lpv-prignitz-ruppin.de',
            subject: 'HEADS UP!!! Neuer oder geänderter Eintrag auf dem "Grünen Brett"',
            body: body
          )

          Success(mail)
        end.to_result
      end

      def log_mail(mail)
        Try[IOError] do
          logger.info(mail)
        end.to_result
      end
    end
  end
end
