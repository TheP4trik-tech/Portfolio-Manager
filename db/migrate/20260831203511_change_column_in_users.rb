class ChangeColumnInUsers < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :error_mail_accepted, :boolean, default: true
  end
end
