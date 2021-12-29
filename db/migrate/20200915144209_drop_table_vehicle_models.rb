class DropTableVehicleModels < ActiveRecord::Migration[6.0]
  def change
    def down
      drop_table :vehicle_models
    end
  end
end
