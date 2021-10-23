# frozen_string_literal: true

module Mailer
  module Operations
    class RequestConfirmation < HanfBrett::Operation
      include Deps[
        logger: 'application.mail_logger',
        mailer: 'application.mailer',
        view: 'views.confirm_subscription',
      ]

      def call(subscriber)
        mail = yield send_confirmation_mail(subscriber)

        Success(mail: mail, subscriber: subscriber)
      end

      private

      def send_confirmation_mail(subscriber)
        Try[Errno::ECONNREFUSED] do
          body = view.(subscriber: subscriber, format: :txt).to_s
          body_html = view.(subscriber: subscriber, format: :html).to_s

          mail = mailer.(
            from: "Gruenes Brett<no-reply@gruenesbrett.de",
            to: subscriber.email,
            subject:  'Grünes Brett - Automatische Benachrichtigungen bestätigen',
            body: body,
            body_html: body_html
          )

          logger.(:info, mail)

          mail
        end.to_result.or do |x|
          logger.(:error, x)

          Failure[:mail, x]
        end
      end
    end
  end
end


