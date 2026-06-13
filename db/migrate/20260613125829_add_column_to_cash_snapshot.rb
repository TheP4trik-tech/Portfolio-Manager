class AddColumnToCashSnapshot < ActiveRecord::Migration[8.1]
  def change
    add_column :cash_snapshots, :currency, :string
  end
end
