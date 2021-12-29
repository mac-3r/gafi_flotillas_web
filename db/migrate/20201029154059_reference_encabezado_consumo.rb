class ReferenceEncabezadoConsumo < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_consumptions, :consumption
    remove_column :vehicle_consumptions, :fecha_inicio
    remove_column :vehicle_consumptions, :fecha_fin
  end
end
