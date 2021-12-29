class AddFieldToVehiclefiles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_files, :documento, :string
  end
end
