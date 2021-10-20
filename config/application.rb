# frozen_string_literal: true

begin
  require "break"
rescue LoadError => e
  raise unless e.path == "break"
end

require "i18n"
I18n.load_path << Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :de

require "slim"
Slim::Embedded.options[:markdown] = { hard_wrap: true }

require "hanami"

module HanfBrett
  class Application < Hanami::Application
    config.slice :api do
      import :mailer
    end

    config.sessions = :cookie, {
      key: "hanf_brett.session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365 # 1 year
    }

    config.logger = {
      level: :debug,
      stream: settings.log_to_stdout ? $stdout : "log/#{Hanami.env}.log"
    }

    config.actions.default_headers = {
      "X-Frame-Options" => "DENY",
      "X-Content-Type-Options" => "nosniff",
      "X-XSS-Protection" => "1; mode=block",
      "Content-Security-Allow-Origin" => "http://localhost:*",
      "Content-Security-Policy" => \
      "default-src 'self' 'unsafe-eval' 'unsafe-inline' http://localhost:* data: http://placekitten.com https://fonts.googleapis.com https://www.google.com https://www.gstatic.com;" \
      "font-src 'self' 'unsafe-eval' 'unsafe-inline' http:; "
    }
  end
end
