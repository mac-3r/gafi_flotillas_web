class CreateVehiclesMasters < ActiveRecord::Migration[6.0]
  def change
    create_view :vehicles_masters
  end
end
