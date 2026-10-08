class AddOpenRateToStocks < ActiveRecord::Migration[8.1]
  def change
    add_column :stocks, :open_rate, :decimal, null: false, precision: 10, scale: 2
  end
end
