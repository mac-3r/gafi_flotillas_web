class EliminarVehicleItem < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_items, :string
    remove_column :vehicle_items, :date
    remove_column :vehicle_items, :fecha_compra
    add_column :vehicle_items, :fecha_compra, :date
    
  end
end
