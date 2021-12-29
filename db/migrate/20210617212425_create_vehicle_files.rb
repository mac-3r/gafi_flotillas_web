class CreateVehicleFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_files do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.integer :clave
      t.string :nombre_archivo
      t.string :tipo_archivo

      t.timestamps
    end
  end
end
