class CreateVehicleModels < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_models do |t|
      t.string :clave
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
