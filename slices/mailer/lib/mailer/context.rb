module Mailer
  class Context < Hanami::View::Context
    include Deps[
      'application.assets'
    ]

    def initialize(**args)
      defaults = {content: {}}

      super(**defaults.merge(args))
    end

    def content_for(key, value = nil, &block)
      content = _options[:content]
      output = nil

      if block
        content[key] = yield
      elsif value
        content[key] = value
      else
        output = content[key]
      end

      output
    end
  end
end
