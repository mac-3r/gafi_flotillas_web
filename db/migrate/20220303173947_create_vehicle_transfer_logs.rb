class CreateVehicleTransferLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_transfer_logs do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_branch, null: false, foreign_key: true
      t.integer :cedis_ant_id
      t.references :user, null: false, foreign_key: true
      t.datetime :fecha

      t.timestamps
    end
  end
end
