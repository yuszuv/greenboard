require 'mail'

module HanfBrett
  class Mailer
    # include Deps['loggering.mail_logger']

    def call(from:, to:, subject:, body:)
      mail = Mail.new
      mail.from = from
      mail.to = to
      mail.subject = subject
      mail.body = body

      mail.deliver!

      mail
    end
  end
end
