# frozen_string_literal: true

module Mailer
  module Operations
    class NotifySubscribers < HanfBrett::Operation
      include Deps[
        mailer: 'application.mailer',
        mail_logger: 'application.mail_logger',
        request_confirmation: 'operations.request_confirmation',
        repo: 'repositories.subscriber',
        view: 'views.notify_create'
      ]

      def call(card)
        recipients = repo.active_subscribers

        yield send_notifications(recipients, card)

        Success()
      end

      private

      def send_notifications(recipients, card)
        recipients.map do |recipient|
          # TODO add sidekiq
          send_notification_mail(recipient, card)
        end

        Success()
      end

      def send_notification_mail(recipient, card)
        body = view.(subscriber: recipient, card: card).to_s

        Try[Errno::ECONNREFUSED] do
          mail = mailer.(
            from: "[DEV] Gruenes Brett<no-reply@gruenesbrett.de",
            to: recipient.email,
            subject:  'Grünes Brett - Neuer oder geänderter Eintrag auf dem "Grünen Brett"',
            body: body
          )
          mail_logger.info("Message sent to subscriber: #{recipient.to_s}")
          mail_logger.info(mail.to_s)
          Success(mail)
        end.to_result.or do |x|
          mail_logger.error(x)
          Failure[:mail, x]
        end
      end
    end
  end
end

