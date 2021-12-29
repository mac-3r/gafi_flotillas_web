class CreateVehicleConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_configurations do |t|
      t.string :clave
      t.text :descripcion
      t.string :numero_ejes
      t.string :numero_llantas
      t.string :fecha_inicio_vigencia
      t.string :fecha_fin_vigencia

      t.timestamps
    end
  end
end
