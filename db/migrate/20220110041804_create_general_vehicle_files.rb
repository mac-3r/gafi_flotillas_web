class CreateGeneralVehicleFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :general_vehicle_files do |t|
      t.integer :clave
      t.string :nombre_archivo
      t.string :tipo_archivo
      t.date :fecha_vencimiento
      t.string :documento

      t.timestamps
    end
  end
end
