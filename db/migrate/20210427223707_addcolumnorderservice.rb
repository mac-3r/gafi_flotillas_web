class Addcolumnorderservice < ActiveRecord::Migration[6.0]
  def change
    add_reference :service_orders, :ticket_tire_battery, foreign_key: true, null:true
    add_reference :service_orders, :catalog_vendor, foreign_key: true, null:true
    add_reference :maintenance_controls, :catalog_vendor, foreign_key: true, null:true
  end
end
