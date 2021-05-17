# frozen_string_literal: true

begin
  require "break"
rescue LoadError => e
  raise unless e.path == "break"
end

require 'i18n'
I18n.load_path << Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :de

require "hanami"

module HanfBrett
  class Application < Hanami::Application
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
      "default-src 'self' 'unsafe-eval' 'unsafe-inline' http://localhost:* data: http://placekitten.com; " \
        "font-src 'self' 'unsafe-eval' 'unsafe-inline' http:; "
        # "base-uri 'self'; " \
        # "child-src 'self'; " \
        # "connect-src 'self'; " \
        # "default-src 'none'; " \
        # "form-action 'self'; " \
        # "frame-ancestors 'self'; " \
        # "frame-src 'self'; " \
        # "img-src 'self' https: data:; " \
        # "media-src 'self'; " \
        # "object-src 'none'; " \
        # "script-src 'self' 'unsafe-eval' http://localhost:*; " \
        # "style-src 'self' 'unsafe-inline' http:"
    }
  end
end
