class AddColumnVehicleFiles < ActiveRecord::Migration[6.0]
  def change
  add_column :vehicle_files, :fecha_vencimiento, :date
  end
end
