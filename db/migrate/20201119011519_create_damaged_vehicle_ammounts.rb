class CreateDamagedVehicleAmmounts < ActiveRecord::Migration[6.0]
  def change
    create_view :damaged_vehicle_ammounts
  end
end
