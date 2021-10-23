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

    register :mail_logger, hanami_logger
  end
end

