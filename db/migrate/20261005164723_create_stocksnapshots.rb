class CreateStocksnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :stocksnapshots do |t|
      t.timestamps
    end
  end
end
