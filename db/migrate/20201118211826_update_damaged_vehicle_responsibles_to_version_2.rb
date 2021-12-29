class UpdateDamagedVehicleResponsiblesToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_vehicle_responsibles, version: 2, revert_to_version: 1
  end
end
