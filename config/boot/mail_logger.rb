Hanami.application.register_bootable :mail_logger do |container|
  init do
    require 'hanami/logger'
  end

  start do
    settings = container['settings']

    register :mail_logger, Hanami::Logger.new(
      level: settings.mail_log_level,
      stream: 'log/mail.log'
    )
  end
end

