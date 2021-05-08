# frozen_string_literal: true

require "hanf_brett/types"

Hanami.application.settings do
  # Framework
  setting :log_to_stdout, HanfBrett::Types::Params::Bool.optional.default(false)

  # Database
  setting :database_url, HanfBrett::Types::String

  # Application
  setting :session_secret, HanfBrett::Types::String

  # Assets
  setting :precompiled_assets, HanfBrett::Types::Params::Bool.optional.default(false)
  setting :assets_server_url, HanfBrett::Types::String.optional.default("http://localhost:8080")
end
