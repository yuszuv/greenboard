# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :images do
      primary_key :id
      foreign_key :card_id, :cards
      # column :image_data, JSON
      # column :image_data, JSON
      column :image_data, :json, null: true, default: "{}"
      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    run <<-SQL
    CREATE TRIGGER set_updated_at_on_images
      BEFORE UPDATE ON images FOR EACH ROW
      EXECUTE PROCEDURE set_updated_at_column();
    SQL
  end

  down do
    run <<-SQL
      DROP TRIGGER IF EXISTS set_updated_at_on_cards ON images;
    SQL

    run "DROP FUNCTION IF EXISTS set_updated_at_column();"

    drop_table :images
  end
end
