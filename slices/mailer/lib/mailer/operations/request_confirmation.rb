# frozen_string_literal: true

module Mailer
  module Operations
    class RequestConfirmation < HanfBrett::Operation
      include Deps[
        'application.mail_logger',
        mailer: 'application.mailer',
        view: 'views.confirm_subscription',
        context: 'application.view.context'

      ]

      def call(subscriber)
        yield send_confirmation_mail(subscriber)

        Success(subscriber)
      end

      private

      def send_confirmation_mail(subscriber)
        body = view.(subscriber: subscriber).to_s

        Try[Errno::ECONNREFUSED] do
          mail = mailer.(
            from: "[DEV] Gruenes Brett<no-reply@gruenesbrett.de",
            to: subscriber.email,
            subject:  'Grünes Brett - Automatische Benachrichtigungen bestätigen',
            body: body
          )
          mail_logger.info("Message sent to subscriber: #{subscriber.to_s}")
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


