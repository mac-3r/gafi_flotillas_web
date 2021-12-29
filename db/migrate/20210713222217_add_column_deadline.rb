class AddColumnDeadline < ActiveRecord::Migration[6.0]
  def change
     add_column :deadlines, :estatus, :boolean
     add_reference :consumptions, :deadline, foreign_key: true, null:true
     add_reference :purchase_orders, :deadline, foreign_key: true, null:true
     add_reference :service_orders, :deadline, foreign_key: true, null:true
     add_reference :ticket_tire_batteries, :deadline, foreign_key: true, null:true
     add_reference :vehicle_adaptations, :deadline, foreign_key: true, null:true
  end
end
