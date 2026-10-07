class DeleteMigration < ActiveRecord::Migration[8.1]
  def change
    drop_table :stocksnapshots
  end
end
