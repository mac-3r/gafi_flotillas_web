class AddColumnVehicleAdaptation < ActiveRecord::Migration[6.0]
  def change
      add_column :vehicle_adaptations,:impuestos,:boolean
  end
end
