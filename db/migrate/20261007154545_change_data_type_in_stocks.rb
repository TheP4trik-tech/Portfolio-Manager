class ChangeDataTypeInStocks < ActiveRecord::Migration[8.1]
  def change
    change_column :stocks, :stock_id, :integer, null: false
    rename_column :stocks, :stock_id, :instrument_id
  end
end
