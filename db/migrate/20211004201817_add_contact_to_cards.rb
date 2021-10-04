# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :cards do
      add_column :contact, String
    end
  end
end
