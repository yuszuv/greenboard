# frozen_string_literal: true

require "rack/static"
use Rack::Static,
  urls: ["/assets", "/uploads"],
  root: "public",
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

require "rack/method_override"
use Rack::MethodOverride

require "hanami/boot"
run Hanami.app
