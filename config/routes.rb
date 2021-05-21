# frozen_string_literal: true

Hanami.application.routes do
  slice :main, at: "/" do
    root to: "list_cards"
    get "gruenes_brett", to: "list_cards"
    get "neue_karte", to: "build_card"
    post "karten", to: "create_card"
    get "karte/:id/bearbeiten", to: "edit_card"
    patch "karte/:id", to: "update_card"
    get "karte/:id/loeschbestaetigung", to: "confirm_delete_card"
    delete "karte/:id", to: "delete_card"
  end
end
