Hanami.application.register_bootable :rack_logger do |container|
  init do
    require "dry/monitor/sql/logger"
    require "rouge"
  end

  start do
    require "hanami/web/rack_logger"

    use :logger
    use :rack_monitor

    Dry::Monitor::SQL::Logger.configure do |config|
      config.theme = Rouge::Themes::Gruvbox.tap(&:light!).new
    end

    sql_logger = Dry::Monitor::SQL::Logger.new(container[:logger])

    sql_logger.subscribe(container[:notifications])

    register :sql_logger, sql_logger
  end
end
