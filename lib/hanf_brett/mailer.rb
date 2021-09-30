require 'net/smtp'

module HanfBrett
  class Mailer
    include Dry::Configurable

    setting :smtp_server do
      setting :url, ENV["SMTP_SERVER_URL"]
      setting :port, ENV["SMTP_SERVER_PORT"]
      setting :hostname, ENV["SMTP_SERVER_HOSTNAME"]
      setting :username, ENV["SMTP_SERVER_USERNAME"]
      setting :password, ENV["SMTP_SERVER_PASSWORD"]
      setting :auth_type, ENV["SMTP_SERVER_AUTH_TYPE"].to_sym
    end

    setting :sender, ENV["MAILER_SENDER"]
    setting :recipient, ENV["MAILER_RECIPIENT"]

    def call(message)
      message = <<~MESSAGE_END
        From: #{config.sender}
        To: #{config.recipient}
        Subject: Neuer oder geänderter Eintrag auf dem Grünen Brett

        #{message}
      MESSAGE_END

      Net::SMTP.start(
        config.smtp_server.url,
        config.smtp_server.port,
        config.smtp_server.hostname,
        config.smtp_server.username,
        config.smtp_server.password,
        config.smtp_server.auth_type
      ) do |smtp|
          smtp.send_message message, config.sender, config.recipient
        end
    end
  end
end
