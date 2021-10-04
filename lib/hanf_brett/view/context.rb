# frozen_string_literal: true

require "redcarpet"

require "hanami/view/context"

module HanfBrett
  module View
    class Context < Hanami::View::Context
      include Deps[
        "assets",
        "settings"
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

      def current_path
        request.fullpath
      end

      def csrf_token
        request.session[Hanami::Action::CsrfProtection::CSRF_TOKEN]
      end

      def app_version
        HanfBrett::Application::Version
      end

      def markdown(input)
        renderer = Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true)
        markdown = Redcarpet::Markdown.new(renderer, extensions = {})
        markdown.render(input)
      end
    end
  end
end
