class RenameColumnInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :name, :first_name
    rename_column :users, :surname, :last_name
  end
end
