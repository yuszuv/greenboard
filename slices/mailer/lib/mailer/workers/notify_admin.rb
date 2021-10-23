# frozen_string_literal: true

require 'sidekiq'

module Mailer
  module Workers
    class NotifyAdmin < HanfBrett::Operation
      include Sidekiq::Worker

      include Deps[
        settings: 'application.settings',
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
        end
      rescue NoMatchingPatternError => e
        raise e
      end

      def call(card_id)
        card = yield get_card(card_id)
        body = view.(card: card).to_s
        mail = yield send_mail(body)
        yield log_mail(mail)

        Success(card: card, recipient: mail.to)
      end

      private

      def get_card(id)
        Maybe(repo.find(id)).to_result(:not_found)
      end

      def send_mail(body)
        Try[Errno::ECONNREFUSED] do
          mailer.(
            from: 'no-reply@gruenesbrett.de',
            to: settings.smtp_server_admin_email,
            subject: 'HEADS UP!!! Neuer oder geänderter Eintrag auf dem "Grünen Brett"',
            body: body
          )
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
