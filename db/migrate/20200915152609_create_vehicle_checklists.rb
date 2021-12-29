class CreateVehicleChecklists < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_checklists do |t|
      t.string :clasificacionvehiculo
      t.string :conceptovehiculo
      t.references :vehicle_types, null: false, foreign_key: true

      t.timestamps
    end
  end
end
