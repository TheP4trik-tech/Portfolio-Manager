class RenameModelAndAddColumn < ActiveRecord::Migration[8.1]
  def change
    add_reference :api_credentials, :user, null: false, foreign_key: true
  end
end
