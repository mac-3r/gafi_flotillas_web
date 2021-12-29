class AddColumnMaintenanceControls < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_controls, :tipo, :integer
    add_reference :maintenance_controls, :service_order, foreign_key: true,null: true
  end
end
