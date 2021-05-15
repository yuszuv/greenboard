# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :photos do
      primary_key :id
      foreign_key :card_id, :cards
      # column :image_data, JSON
      column :image_data, String
      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    run <<-SQL
    CREATE TRIGGER set_updated_at_on_photos
      BEFORE UPDATE ON photos FOR EACH ROW
      EXECUTE PROCEDURE set_updated_at_column();
    SQL
  end

  down do
    run <<-SQL
      DROP TRIGGER IF EXISTS set_updated_at_on_cards ON photos;
    SQL

    run "DROP FUNCTION IF EXISTS set_updated_at_column();"

    drop_table :photos
  end
end
