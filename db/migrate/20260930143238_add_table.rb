class AddTable < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.string :name, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :currency, null: false
      t.string :stock_id, null: false
      t.string :icon_uri
      t.timestamps
    end
  end
end
