class UpdateDamagedVehicleAmmountsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_vehicle_ammounts, version: 3, revert_to_version: 2
  end
end
