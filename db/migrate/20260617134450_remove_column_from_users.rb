class RemoveColumnFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :password
  end
end
