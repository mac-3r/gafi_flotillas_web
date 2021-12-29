class CreateVehicleLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_logs do |t|
      t.text :texto
      t.references :user, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
