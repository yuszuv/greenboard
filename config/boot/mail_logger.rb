Hanami.application.register_bootable :mail_logger do |container|
  init do
    require 'hanami/logger'
    require 'mail'
  end

  start do
    settings = container['settings']

    hanami_logger = Hanami::Logger.new(
      level: settings.mail_log_level,
      stream: 'log/mail.log'
    )

    mail_logger = proc do |logger, level, payload|
      if payload.is_a?(Mail::Message)
        logger.public_send(level, "Mail sent!")
      end
      logger.public_send(level, payload)
    end.curry[hanami_logger]

    register :mail_logger, mail_logger
  end
end

