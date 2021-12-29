class CreateOneSignalDevice < ActiveRecord::Migration[6.0]
  def change
    create_table :one_signal_devices do |t|
      t.string :token
      t.string :player_id
      t.datetime :api_token_expires_at
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
