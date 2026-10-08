class AddUnitsToStocks < ActiveRecord::Migration[8.1]
  def change
    add_column :stocks, :units, :decimal
  end
end
