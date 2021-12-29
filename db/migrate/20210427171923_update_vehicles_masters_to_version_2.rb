class UpdateVehiclesMastersToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :vehicles_masters, version: 2, revert_to_version: 1
  end
end
