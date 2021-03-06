# frozen_string_literal: true

require 'rack/contrib'
require "rack/static"
use Rack::Static,
  root: "public",
  urls: ["/uploads", "/assets", "/favicon.ico"],
  cascade: true,
  header_rules: [
    ["/assets", {"Cache-Control" => "public, max-age=31536000"}]
  ]

require "rack/cors"
use Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000', 'https://gruenesbrett.netzwerk-hanf.de'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put]
  end
end

use Rack::JSONBodyParser

require "rack/method_override"
use Rack::MethodOverride

require "hanami/boot"
require_relative 'lib/hanf_brett/middleware/resolve'
require_relative 'lib/hanf_brett/middleware/current_time'

use HanfBrett::Middleware::Resolve
use HanfBrett::Middleware::CurrentTime

run Hanami.app


