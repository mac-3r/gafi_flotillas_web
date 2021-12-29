class AddColumnsOrderServices < ActiveRecord::Migration[6.0]
  def change
    add_reference :service_orders, :order_service_type, foreign_key: true
    add_reference :service_orders, :vehicle, foreign_key: true
    add_column :service_orders, :tipo_servicio, :integer
    add_column :service_orders, :fecha_revision_propuesta, :date
    add_reference :service_orders, :catalog_workshop, foreign_key: true
    add_reference :maintenance_appointments, :service_order, foreign_key: true
  end
end
