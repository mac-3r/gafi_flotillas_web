class CreateMaintenanceDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_details do |t|
      t.string :categoria
      t.string :descripcion
      t.decimal :frecuencia_reemplazo
      t.decimal :frecuencia_inspeccion
      t.string :servicio

      t.timestamps
    end
  end
end
