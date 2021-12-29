class CambioNulo < ActiveRecord::Migration[6.0]
  def change
    remove_column :maintenance_controls, :catalog_branch_id
    change_column :maintenance_controls, :vehicle_id, :integer, null:true
    change_column :maintenance_controls, :catalog_workshop_id, :integer, null:true
    change_column :maintenance_controls, :catalog_repair_id, :integer, null:true
  end
end
