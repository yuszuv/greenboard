# frozen_string_literal: true

Hanami.application.routes do
  slice :main, at: "/" do
    root to: "list_cards"
    get "neue_karte", to: "build_card"
    post "karten", to: "create_card"
    get "karte/:id/bearbeiten", to: "edit_card"
    patch "karte/:id", to: "update_card"
    get "karte/:id/loeschbestaetigung", to: "confirm_delete_card"
    get "karte/:id/kontaktdaten", to: "show_contact_data"
    delete "karte/:id", to: "delete_card"
  end

  slice :api, at: '/api' do
    post "cards", to: 'create_card'
    get "cards/:id", to: "get_card"
    patch "cards/:id", to: "update_card"
    post "cards/:id/authorize", to: "authorize_card"

    post "images", to: "upload_image"
  end
end
