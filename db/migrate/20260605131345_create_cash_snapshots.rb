class CreateCashSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :cash_snapshots do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency, null: false
      t.decimal :total_value, null: false
      t.decimal :profit
      t.decimal :free_cash, null: false
      t.timestamps
    end
  end
end
