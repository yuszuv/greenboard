# frozen_string_literal: true

Hanami.application.routes do
  if Hanami.env?(:development)
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'
  end

  slice :frontend, at: "/" do
    root to: "list_cards"
    get "abonnement_bestaetigen", to: 'confirm_subscription'
    get "abonnement_loeschen", to: 'delete_subscription'
  end

  slice :api, at: '/api' do
    get "cards", to: "list_cards"
    post "cards", to: 'create_card'
    get "cards/:id", to: "get_card"
    patch "cards/:id", to: "update_card"
    delete "cards/:id", to: "delete_card"
    get "cards/:id/contact_data", to: "show_contact_data"
    post "cards/:id/authorize", to: "authorize_card"

    post "images", to: "upload_image"

    post "subscribe_updates", to: "subscribe_updates"
  end
end
