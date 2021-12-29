class AddWarehouseToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicles, :warehouse
  end
end
