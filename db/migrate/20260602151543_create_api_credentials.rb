class CreateApiCredentials < ActiveRecord::Migration[8.1]
  def change
    create_table :api_credentials do |t|
      t.string :api_key
      t.string :api_id
      t.string :provider

      t.timestamps
    end
  end
end
