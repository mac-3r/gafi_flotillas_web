class AddColumnVehicleAdaptationsDate < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_adaptations, :fecha, :date
  end
end
