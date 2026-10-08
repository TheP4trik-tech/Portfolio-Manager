class RemoveUnitsFromStocks < ActiveRecord::Migration[8.1]
  def change
    remove_column :stocks, :units
  end
end
