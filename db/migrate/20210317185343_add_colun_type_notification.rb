class AddColunTypeNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :tipo, :integer
    add_reference :catalog_workshops, :user, foreign_key: true
    change_column_null :service_orders, :maintenance_program_id, true
    change_column_null :service_orders, :maintenance_appointment_id, true
  end
end
