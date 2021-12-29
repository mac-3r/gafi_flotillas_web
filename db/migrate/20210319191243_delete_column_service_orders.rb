class DeleteColumnServiceOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :service_orders, :maintenance_appointment_id
  end
end
