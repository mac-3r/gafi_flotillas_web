class AddForeignConsumo < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_consumptions, :vehicle, null: true
    add_reference :vehicle_consumptions, :catalog_brand, null: true
    add_reference :vehicle_consumptions, :catalog_area, null: true
    add_reference :vehicle_consumptions, :responsable, null: true
    remove_column :vehicle_consumptions, :no_economico
    remove_column :vehicle_consumptions, :desc_linea
    remove_column :vehicle_consumptions, :grupo
    remove_column :vehicle_consumptions, :responsable
  end
end
