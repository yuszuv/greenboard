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

  setting :smtp_server_url, HanfBrett::Types::String
  setting :smtp_server_port, HanfBrett::Types::Coercible::Integer
  setting :smtp_server_username, HanfBrett::Types::String
  setting :smtp_server_password, HanfBrett::Types::String
  setting :smtp_server_admin_email, HanfBrett::Types::String

  setting :mail_log_level, HanfBrett::Types::String
end
