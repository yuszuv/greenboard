# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :cards do
      add_column :notification_sent_at, DateTime
    end
  end
end
