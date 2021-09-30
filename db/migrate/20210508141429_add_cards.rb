# frozen_string_literal: true

ROM::SQL.migration do
  up do
    sql = <<-SQL
      CREATE OR REPLACE FUNCTION set_updated_at_column() RETURNS TRIGGER AS $$
      BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
        RETURN NEW;
      END;
      $$ language 'plpgsql';
    SQL
    run sql

    create_table :cards do
      primary_key :id
      column :topic, String, null: false
      column :text, String, null: false
      column :type, String, null: false
      column :author, String
      column :password, String, null: false
      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    run <<-SQL
      CREATE TRIGGER set_updated_at_on_cards
        BEFORE UPDATE ON cards FOR EACH ROW
        EXECUTE PROCEDURE set_updated_at_column();
    SQL
  end

  down do
    run <<-SQL
      DROP TRIGGER IF EXISTS set_updated_at_on_cards ON cards;
    SQL

    run "DROP FUNCTION IF EXISTS set_updated_at_column();"

    drop_table :cards
  end
end
