class AddColumnToApiCredentials < ActiveRecord::Migration[8.1]
  def change
    add_column :api_credentials, :error_sent, :boolean, default: false
  end
end
