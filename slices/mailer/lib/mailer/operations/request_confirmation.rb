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

      def call(subscriber, request)
        res = yield send_confirmation_mail(subscriber, request)

        Success(res)
      end

      private

      def send_confirmation_mail(subscriber, request)
        host = "%s://%s" % [request.scheme, request.env['HTTP_HOST']]

        body = view.(subscriber: subscriber, host: host).to_s

        Try[Errno::ECONNREFUSED] do
          mail = mailer.(
            from: "[DEV] Gruenes Brett<no-reply@gruenesbrett.de",
            to: subscriber.email,
            subject:  'Grünes Brett - Automatische Benachrichtigungen bestätigen',
            body: body
          )
          mail_logger.info("Message sent to subscriber: #{subscriber}")
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


