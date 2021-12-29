class ChangeVehicleColums < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :recibido, :boolean, :default => false
    add_reference :purchase_orders, :ticket_tire_battery, foreign_key: true, null:true
    add_reference :purchase_details, :catalog_tires_battery, foreign_key: true
  end
end
