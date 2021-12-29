class RemoveColumnVehiclechecklist < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_checklists, :vehicle_types_id, :integer
    add_reference :vehicle_checklists, :vehicle_type
  end
end
