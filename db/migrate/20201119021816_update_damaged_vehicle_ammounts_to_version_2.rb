class UpdateDamagedVehicleAmmountsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_vehicle_ammounts, version: 2, revert_to_version: 1
  end
end
