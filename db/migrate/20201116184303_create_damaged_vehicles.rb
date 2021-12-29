class CreateDamagedVehicles < ActiveRecord::Migration[6.0]
  def change
    create_view :damaged_vehicles
  end
end
