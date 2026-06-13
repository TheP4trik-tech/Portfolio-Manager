class CreateCashSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :cash_snapshots do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_balance
      t.decimal :available_cash
      t.decimal :total_investments
      t.decimal :profit_loss

      t.timestamps
    end
  end
end
