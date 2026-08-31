class AddColumnsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :error_mail_accepted, :boolean, default: false
    add_column :users, :daily_mail_accepted, :boolean, default: true
    end
end
