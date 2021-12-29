class UpdateDamagedVehicleResponsiblesToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_vehicle_responsibles, version: 3, revert_to_version: 2
  end
end
