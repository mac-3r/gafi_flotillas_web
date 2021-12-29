class CreateVehicleStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_statuses do |t|
      t.string :nombre
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
