class AddColumnMaintenanceFrencuences < ActiveRecord::Migration[6.0]
  def change
    add_reference :maintenance_frecuencies, :vehicle_type, foreign_key: true
    add_reference :maintenance_frecuencies, :catalog_model, foreign_key: true
    remove_column :maintenance_frecuencies, :vehicle_id
  end
end
