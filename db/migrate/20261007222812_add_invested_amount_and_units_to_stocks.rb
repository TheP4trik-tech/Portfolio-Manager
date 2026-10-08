class AddInvestedAmountAndUnitsToStocks < ActiveRecord::Migration[8.1]
  def change
    add_column :stocks, :invested_amount, :decimal
    add_column :stocks, :units, :decimal
    remove_column :stocks, :open_rate
  end
end
