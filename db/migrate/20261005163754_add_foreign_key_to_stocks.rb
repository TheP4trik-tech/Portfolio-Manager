class AddForeignKeyToStocks < ActiveRecord::Migration[8.1]
  def change
    add_reference :stocks, :stock_snapshot, null: false, foreign_key: true
  end
end
