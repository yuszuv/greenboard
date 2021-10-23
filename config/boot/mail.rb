Hanami.application.register_bootable :mail, namespace: true do |container|
  init do
    require 'mail'
  end

  start do
    settings = container['settings']

    Mail.defaults do
      delivery_method :smtp,
        address: settings.smtp_server_url,
        port: settings.smtp_server_port,
        user_name: settings.smtp_server_username,
        password: settings.smtp_server_password,
        enable_starttls: true,
        openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    end
  end
end
