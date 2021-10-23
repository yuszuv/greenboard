require 'mail'

module HanfBrett
  class Mailer
    def call(from:, to:, subject:, body:, body_html: nil)
      mail = Mail.new do
        text_part do
          body body
        end

        if body_html
          html_part do
            content_type 'text/html; charset=UTF-8'
            body body_html
          end
        end
      end

      mail.from = from
      mail.to = to
      mail.subject = subject

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
