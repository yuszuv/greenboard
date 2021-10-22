require 'mail'

module HanfBrett
  class Mailer
    def call(from:, to:, subject:, body:)
      mail = Mail.new
      mail.from = from
      mail.to = to
      mail.subject = subject
      mail.body = body

      mail = append_to_subject(mail) if Hanami.env?(:development, :test)

      mail.deliver!

      mail
    end

    private

    def append_to_subject(mail)
      mail.subject = "[%s] %s" % [Hanami.env, mail.subject]
      mail
    end
  end
end
