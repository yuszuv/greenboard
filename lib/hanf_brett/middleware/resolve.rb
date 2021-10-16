# auto_register: false

require 'dry/effects'

module HanfBrett
  module Middleware
    class Resolve
      include ::Dry::Effects::Handler.Resolve

      def initialize(app)
        @app = app
        @overridable = Hanami.env?(:test)
      end

      def call(env)
        context = {
          host: "%s://%s" % [
            env['rack.url_scheme'],
            env['HTTP_HOST']
          ]
        }
        provide(context, overridable: @overridable) { @app.(env) }
      end
    end
  end
end
