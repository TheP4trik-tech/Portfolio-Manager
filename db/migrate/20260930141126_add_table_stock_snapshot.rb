class AddTableStockSnapshot < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_snapshots do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_value, null: false, precision: 10, scale: 2
      t.string :currency, null: false
      t.string :stock_broker, null: false
      t.timestamps
      end
  end
end
