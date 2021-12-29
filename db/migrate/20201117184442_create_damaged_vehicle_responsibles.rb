class CreateDamagedVehicleResponsibles < ActiveRecord::Migration[6.0]
  def change
    create_view :damaged_vehicle_responsibles
  end
end
