class AddColumnVehiclesFuel < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :rendimiento_ideal, :decimal
  end
end
