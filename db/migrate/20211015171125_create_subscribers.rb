# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :subscribers do
      primary_key :id
      column :email, String, null: false
      column :confirmation_token, String, null: false
      column :confirmed_at, Time

      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    run <<-SQL
      CREATE TRIGGER set_updated_at_on_subscribers
        BEFORE UPDATE ON subscribers FOR EACH ROW
        EXECUTE PROCEDURE set_updated_at_column();
    SQL
  end

  down do
    run <<-SQL
      DROP TRIGGER IF EXISTS set_updated_at_on_subscribers ON subscribers;
    SQL

    drop_table :subscribers
  end
end
