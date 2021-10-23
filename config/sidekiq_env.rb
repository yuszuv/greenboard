require_relative 'application'

Hanami.application.boot
# TODO
# require 'bugsnag'

Sidekiq.configure_server do |config|
  #   config.error_handlers << Proc.new { |ex, ctx_hash| Bugsnag.notify(ex, ctx_hash) }

  require_relative "../spec/support/sidekiq"

  context = {
    host: ENV['APP_DOMAIN']
  }

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add DependencyProvider, context: context
    end
  end
end
