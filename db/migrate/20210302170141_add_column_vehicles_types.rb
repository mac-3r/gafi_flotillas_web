class AddColumnVehiclesTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_types, :rendimiento_ideal, :decimal
  end
end
